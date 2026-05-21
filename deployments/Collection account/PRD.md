# Collection account Automation (Merchant layer)

# Overview

Currently, merchants manually request collection accounts through Tazapay support or their sales counterpart. This works fine for merchants who want a static VAs for their collections. But for fintechs and similar platforms that need VAs for their customers, manual VA creation does not work. We need a way for them to be able to integrate with us and request for VAs on the fly as soon as they onboard their customers. This will include both **virtual bank accounts (VAs)** and **cryptocurrency wallets** across various blockchains. 

**This will also contribute in solving the treasury problem** as it will definitely increase the merchant balances that are parked with Tazapay. Integrated collection account creation > More collection accounts created with Tazapay > More collects > More money being parked with Tazapay.

# **Designs**

https://www.figma.com/design/XZ819hK9zRwVWq32HwaG8Q/Collect-account-Automation?node-id=533-12427

# User Stories

## Part 1 : Request VAs via API

## MUS1 → Users should be able to fetch collection account details via the Metadata API

### User and Objectives

- The user is any API integrated merchant of Tazapay

- Their objective is to fetch our collection account capabilities

### Functional Requirements and Validations

- Create a Metadata API endpoint for the merchants with the following fields - https://docs.google.com/spreadsheets/d/15z84Iu4qRC8kb9GpFaXOmtC1-jrs7tHzs7y-qjN3WU8/edit?gid=833458334#gid=833458334.
- The data would be fetched by some external workflow like N8N , reason being we want to keep the capabilities business facing. Any business stakeholder should be able to come and edit these capabilities without engineering intervention.
- Sample Request and Response for GET [https://service-sandbox.tazapay.com/v3/metadata/collection_accounts/virtual_account](https://service-sandbox.tazapay.com/v3/metadata/collection_accounts/virtual_account)
    - Request
        
        ```json
        {
        	"country" : "DK", // optional
        	"currency" : "DKK", // optional when in product, mandatory - n8n
        }
        ```
        
        - Response
            
            ```json
            {
            	"country" : "DK",
            	"type" : "virtual_account",
            	"capabilities" : [
            		{
            			"payment_method_type": "swift",
            			"currencies" : ["JPY", "AUD", "HKD", "CNH", "USD", "SGD", "CAD", "GBP", "EUR", "CHF", "DKK", "NOK", "SEK", "NZD"],
            			"compliance_requirements": ["full_kyb_required_for_business"],
            			"transfer_limit": {
            				"minimum": 1,
            				"maximum": 1000000,
            				"currency": "USD"
            			},
            			"on_behalf_of":{
            				"supported": true,
            				"restricted_industry_verticals" : []
            			},
            			"setup_time":"same_day",
            			"restricted_remitter_countries": [],
            			"provider":"currency_cloud",
            			"acccount_provider":"Danske Bank"
            		},
            		{
            			"payment_method_type": "local",
            			"currencies" : ["DKK"],
            			"complaince_requirements": ["soft_onboarding_required_for_individuals", "full_kyb_required_for_business"],
            			"transfer_limit": {
            				"minimum": 1,
            				"maximum": 10000,
            				"currency": "DKK"
            			},
            			"on_behalf_of":{
            				"support": true,
            				"restricted_industry_verticals" : []
            			},
            			"setup_time":"t_plus_2",
            			"restricted_sender_countries": [],
            			"acccount_provider":"Danske Bank",
            			"provider":"currency_cloud"
            			"local" : {
            				"fund_transfer_networks" : {
            					"tips" : {
            						"transfer_limit" : {
            							"minimum": 1,
            							"maximum": 1000,
            							"currency": "DKK"
            						},
            						"additional_information": "TIPS is prioritised for instant, real-time collects on a 24/7 basis."
            					},
            					"kranos2":{
            						"transfer_limit" : {
            							"minimum": 1000,
            							"maximum": 10000,
            							"currency": "DKK"
            						},
            						"additional_information": "KRONOS2 is used for large-value or time-critical collects requiring real-time gross settlement."
            					},
            					}
            				}
            			}
            		}
            	]
            }
            ```
            
    - Sample Request and Response for GET [https://service-sandbox.tazapay.com/v3/metadata/collection_accounts/](https://service-sandbox.tazapay.com/v3/metadata/collection_accounts/virtual_account)wallet
        
        Request 
        
        ```jsx
        {
        	"type" : "Ethereum"
        }
        ```
        
        Response 
        
        ```jsx
        [
        	{
        		"type" : "Ethereum",
        		"payment_method_type": "stablecoin_USDT",
        		"currencies" : ["USD"]
        		"compliance_requirements": ["full_kyb_required_for_business"],
        		"transfer_limit": {
        			"minimum": 1,
        			"maximum": 1000000,
        			"currency": "USD"
        		},
        		"on_behalf_of":{
        			"supported": true,
        			"restricted_industry_verticals" : []
        		},
        		"setup_time":"instant",
        		"restricted_sender_countries": [],
        		"provider":"ripple",
        		"acccount_provider":"Danske Bank"
        	},
        	{
        		"type" : "Ethereum",
        		"payment_method_type": "stablecoin_USDC",
        		"currencies" : ["USD"]
        		"compliance_requirements": ["full_kyb_required_for_business"],
        		"transfer_limit": {
        			"minimum": 1,
        			"maximum": 1000000,
        			"currency": "USD"
        		},
        		"on_behalf_of":{
        			"supported": true,
        			"restricted_industry_verticals" : []
        		},
        		"setup_time":"instant",
        		"restricted_sender_countries": [],
        		"provider":"ripple",
        		"acccount_provider":"Danske Bank"
        	},
        ]
        	
        ```
        
        - **Key Decisions -**
            1. If same capability (same set of currencies in same country) is being provided by two providers then show the higher rank provider in the metadata response.
            2. The metadata API will accept an optional `on_behalf_of` query parameter, defaulting to `false`. When `false`, the API filters capabilities based on the merchant's own industry vertical against the top-level `restricted_industry_verticals` — hiding any capability where the merchant's industry is restricted. When `true`, the API returns all supported capabilities regardless of the merchant's industry, along with the `on_behalf_of.restricted_industry_verticals` list so the merchant can see which entity industries are blocked at VA creation time. This decouples the display logic from environment-level configs like `entity_config`, solving the sandbox problem where that flag is always on, and puts control explicitly in the hands of the caller. 
            3. ~~Metadata API responses should also be filtered based on the merchant account specific rules engine, say for example a provider does not support a merchant’s industry vertical then we do not want to show that provider results in the response.~~
            4. For local capabilities lets show the minimum and maximum limits to the users in local currencies, whereas for swift and crypto collects we will show in USD.
- Add pagination in Metadata API response.

## MUS2 → User wants to request VA enablement/disablement via API

### User and Objectives

- The user is any API integrated merchant for whom collection  config is turned on.
- Their objective is to request VA/wallet creation via API.

### Functions Requirements and Validations

- User can create, fetch, disable collection account via the collection account API endpoint
- We will create an endpoint for collection account -  **/v3/collection_account**
    - Collection Account API structure -  https://docs.google.com/spreadsheets/d/15z84Iu4qRC8kb9GpFaXOmtC1-jrs7tHzs7y-qjN3WU8/edit?gid=74724100#gid=74724100
- Replicate the same behaviour for **sandbox API’s**
- Key Decisions -
    - If the merchant request is not supported (verify this via metadata) by Tazapay globally or for that particular merchants, throw API error -
        
        `We do not have the capability to create the requested account.`
        
        In this case, we will not create any request on the system, this request should be rejected at the API layer itself.
        
    - Requested currencies need not be exact match of the supported currencies, it should just be a subset of our capabilities.
    - Once we have made sure that we can accept the request using the metadata API, we will now fetch the provider ranking from N8N workflow.
    - A collection account can have multiple requests linked to it , both enablement and disablement. **Analogy** - Request to collection account is what payout attempt is to payout.
    - Request structure -
    
    ```jsx
    {
    	"id":"cvar_1123/cwar_123"
    	"type":"enablement/disablement",
    	"status":"processing/failed/succeeded/requires_action/approval_hold",
    	"created_at":"",
    	"updated_at":"",
    	"status_description":"" //will contain both failure code and failure reason
    	"psp_reference_id":"", //internal
    	"provider":"", //internal
    	"account_provider":"" //bank name
    }
    ```
    
    This is how the request status flow will work - :
    

![Screenshot 2026-02-26 at 4.37.15 PM.png](Collection%20account%20Automation%20(Merchant%20layer)/Screenshot_2026-02-26_at_4.37.15_PM.png)

### **All Possible State Flows**

```jsx
1. NOT_INITIATED → INITIATED → SUCCEEDED

2. NOT_INITIATED → INITIATED → FAILED

3. NOT_INITIATED → INITIATED → PROCESSING_RETRY → SUCCEEDED

4. NOT_INITIATED → INITIATED → PROCESSING_RETRY → FAILED 

5. NOT_INITIATED → INITIATED → REQUIRES_ACTION → SUCCEEDED

6. NOT_INITIATED → INITIATED → REQUIRES_ACTION → FAILED

7. APPROVAL_HOLD → NOT_INITIATED -> INITIATED → SUCCEEDED

8. APPROVAL_HOLD → NOT_INITIATED → INITIATED → FAILED

9. APPROVAL_HOLD → NOT_INITIATED → INITIATED → REQUIRES_ACTION → SUCCEEDED

10. APPROVAL_HOLD → NOT_INITIATED → INITIATED → REQUIRES_ACTION → FAILED
```

Note - There will be no approval hold for disablement requests.

### State Mappings Internal | External | VA Status

These are the external states mapping to internal states and the internal states mapping to the VA/wallet status

| **Internal request states** | **External request States** | **VA/wallet status - Enablement Request** | **VA/wallet status - disablement request** |
| --- | --- | --- | --- |
| Not initiated | Processing | Disabled | Enabled |
| Initiated | Processing | Disabled | Enabled |
| requires action | Requires action | Disabled | Enabled |
| approval hold | Approval hold | Disabled | Enabled |
| succeeded | Succeeded | **Enabled** | **Disabled** |
| failed | Failed | Disabled | Enabled |
| processing retry | Processing | Disabled | Enabled |
| cancelled | cancelled | Disabled | Enabled |

- External states Handling -
    - **Approval hold** - A request will move to this state if a underlying entity is in on approval hold and we cannot create VAs without entity approval
    - **Requires action -** This action will be triggered by OPS, when there are some actions required on a request , for example document upload. On the merchant dashboard user should be able to attach a document to the collection account request from the actions column.
        - User should also be able to upload this via the document API using resource id as the collection account id
        - On the dashboard also , any request in requires action should allow the merchant to upload the requested document which the operations dashboard user will be able to see with the account.
    - **Processing Retry (internal state) -** The request should move to processing retry if we receive a failure code from a provider which can actually succeed if we try again or if we actually use an alternate provider. (will also provide error code mapping for a integrated providers). When the user (ops dashboard user) retries a processing retry request i.e moves it again to initiated state, the current request would fail and a new request will get created. (**similar to how payouts state work)**
    

## MUS3 → Merchant wants to verify the fees they paid for a collection account creation.

### User and Objectives

- The user is any API integrated merchant of Tazapay
- Their objective is to be able to verify the fees that they paid for a particular collection account creation

### Functions Requirements and Validations

- This setup fees will be a configuration on operations dashboard, nevertheless we will have a default fees configured in the system for each account capability that we support. There can be two types of fees associated with a collection account creations -
    - one_time_setup_fee
    - maintenance_fee
- There needs to be a logic in the system where we deduct the yearly set of fees every year if the account is still enabled.
- **Balance Transaction structure** - The type of balance transaction would be collection_account_creation.
    
    ```jsx
    {
      "id": "btr_ABC1234XYZ",
      "object": "balance_transaction",
      "type": "collection_account_creation",
      "operation_type": "debit",
      "created_at": "2024-02-24T18:00:00Z",
      "amount": 0,
      "currency": "USD",
      "description": "Collection Account Setup fees",
      "fee_details": [
    	  {
    	      "type": "one_time_setup_fee",
    	      "amount": -50,
    	      "currency": "USD"
    	    },
    	    {
    	      "type": "maintenance_fee",
    	      "amount": -1,
    	      "currency": "USD"
    	      "frequency" : "monthly/yearly"
    	    }
        ],
      "fx_conversions": [],
      "net": {
        "amount": -51,
        "currency": "USD"
      },
      "source": "cva_ABC123XYZ"
      "metadata":{}
    }
    ```
    

## MUS4 → User wants to control access to request VA/wallet creation permissions

### User and Objectives

- The user is any API integrated or dashboard merchant of Tazapay
- Their objective is to control access to request VA/wallet creation permissions

### Functions Requirements and Validations

- There will be a new set of permission under RBAC - Collection account
    - Add a new tab - Global Collection account, add the following permissions in it -
        - View
        - Manage account  //This includes creating enablement and disablement requests
    - By default , existing manager users will have view permissions
    - By default , when a new team member is invited , View permission will be ticked.

## MUS5 → User wants to receive a webhook and a email when the state of collection account changes

### User and Objectives

- The user is any API integrated merchant of Tazapay or a user of the Tazapay merchant dashboard
- Their objective is to get notified when the state of collection account changes.

### Functions Requirements and Validations

- Currently we have two events for collection accounts - 
collection_account.creation_succeeded
collection_account.disablement_succeeded,

**Email content** - We already send these emails for the two existing webhook events but lets add the supported currencies in the email for better user experience.

```jsx
Dear <username>,

Your collection account is disabled successfully.
<View Account Details CTA>

Account Details 

Account               |       Account Name 
															Account Number
Supported Currencies  |       USD, SGD
Transfer Type         |       SWIFT
```

- collection_account.creation_succeeded
    
    ```jsx
    Dear <username>,
    
    Your collection account is enabled successfully.
    <View Account Details CTA>
    
    Account Details 
    
    Account               |       Account Name 
    															Account Number
    Supported Currencies  |       USD, SGD
    Transfer Type         |       SWIFT
    ```
    
- Moving forward we want to add the following webhook events corresponding to collection account requests-
    - collection_account.creation_failed (The field that are yet not populated will remain blank like the account number). The status of collection account here will be `failed`.
        
        Email Content - 
        
        ```jsx
        Dear <username>,
        
        Your collection account enablement request has failed as <failure_reason>.
        <View Account Details CTA>
        
        Account Details 
        
        Account               |       Account Name 
        Requested Currencies  |       USD, SGD
        Transfer Type         |       SWIFT
        ```
        
    - collection_account.creation_requires_action / collection_account.disablement_requires_action
        
        ```jsx
        Dear <username>,
        
        Your collection account enablement/disablement request requires_action
        <View Account Details CTA>
        
        Account Details 
        (For disablement)
        Account               |       Account Name 
        Requested Currencies  |       USD, SGD
        Transfer Type         |       SWIFT
        
        (For disablement)
        
        Account               |       Account Name 
        															Account Number
        Supported Currencies  |       USD, SGD															
        Transfer Type         |       SWIFT
        ```
        
    - collection_account.creation_under_approval_hold
        
        ```jsx
        Dear <username>,
        
        Your collection account enablement/disablement 
        request is under approval hold as the entity 
        requires approval.
        <View Account Details CTA>
        
        Account Details 
        (For disablement)
        Account               |       Account Name
        Entity id             |       entity id
        Requested Currencies  |       USD, SGD
        Transfer Type         |       SWIFT
        ```
        
    - collection_account.creation_under_processing / collection_account.disablement_under_processing
        
        ```jsx
        Dear <username>,
        
        Your collection account enablement/disablement request is being processed
        <View Account Details CTA>
        
        Account Details
        (For disablement)
        Account               |       Account Name
        Requested Currencies  |       USD, SGD
        Transfer Type         |       SWIFT
        
        (For disablement)
        
        Account               |       Account Name
        															Account Number
        Supported Currencies  |       USD, SGD
        Transfer Type         |       SWIFT
        ```
        
    - collection_account.creation_cancelled / collection_account.disablement_cancelled
        
        ```jsx
        Dear <username>,
        
        Your collection account enablement/disablement request has been cancelled.
        <View Account Details CTA>
        
        Account Details
        (For disablement)
        Account               |       Account Name
        Requested Currencies  |       USD, SGD
        Transfer Type         |       SWIFT
        
        (For disablement)
        
        Account               |       Account Name
        															Account Number
        Supported Currencies  |       USD, SGD
        Transfer Type         |       SWIFT
        ```
        
    - collection_account.disablement_failed. The status of collection account here will be `enabled`.
    
    ```jsx
    Dear <username>,
    
    Your collection account disablement request has failed as <failure_reason>.
    <View Account Details CTA>
    
    Account Details 
    
    Account               |       Account Name 
    															Account Number
    Supported Currencies  |       USD, SGD
    Transfer Type         |       SWIFT
    ```
    
- Replicate the behaviour on sandbox environment

## **MUS6 → Create a listing API for collection accounts**

## User and Objectives

- The user is any API integrated merchant of Tazapay
- Their objective is to fetch the list of collection accounts linked to their account via API

### Functions Requirements and Validations

1. Create a listing API endpoint - GET /v3/collection_account
2. check structure - https://docs.google.com/spreadsheets/d/15z84Iu4qRC8kb9GpFaXOmtC1-jrs7tHzs7y-qjN3WU8/edit?gid=0#gid=0

## Part 2 : Request VAs via dashboard

## MUS7 → User wants to request for VA enablement via dashboard

### User and Objectives

- The user is any user of the Tazapay merchant dashboard with collections enabled
- Their objective is to request VA creation from the dashboard

### Functional Requirements and Validations

- Collection account tab will always be visible to users irrespective of collections is enabled or not -
    - Collections not enabled - `Collections are currently not enabled for your account. Please contact [support@tazapay.com](mailto:support@tazapay.com) to activate this feature`
    - Collections enabled - `You're almost there! No collection accounts are linked to your account yet. Add one to start receiving collects.` Also lets a put a `Add Collection Account CTA .
- Users will see an option on Virtual account/ wallet tab to request for a new collection account - Request Virtual account/Request Stablecoin Wallet .
- Accordingly , we will show the required form
    1. Wallet (following are in an ordered manner) -  
        1. Entity Id
        2. Description
        3. Currency (only US as a option - this will be a pre-filled field for now)
        4. Alias - Add a i button (Add a nick name to easily identify your account)
        5. Stablecoin Type(USDT/USDC)
        6. Once the above are selected stablecoin Type, we will show the list of available blockchains 
    2. VA - Account holder type - 
        1. Entity Id - If entity creation for collects config is enabled for that account user should have an option to enable entity and be able to see a list of entity ids dynamically and user can select an entity from dropdown or create a new one similar to how we do for payouts.
        2. Description
        3. Alias - Add a i button (Add a nick name to easily identify your account) [**Optional**]
        4. Country
        5. After they select country, a list of VA options will be displayed, this is going to be pulled from the Metadata API + Rules engine response .The following details will be available for each VA
            1. Currencies
            2. Domicile country
            3. Transfer Type   
            4. Setup cost - If negotiated then we show that from the ops dashboard , otherwise we should the default pricing.
            - Setup Time
            - Overall transaction limit
            - For Local -
                - We will show the available fund transfer networks
            
            Design inspiration from Airwallex, but here the first input is country, for us this is going to be currency -:
            
            ![Screenshot 2025-09-30 at 11.48.03 PM.png](Collection%20account%20Automation%20(Merchant%20layer)/Screenshot_2025-09-30_at_11.48.03_PM.png)
            
            ![Screenshot 2025-09-30 at 11.48.11 PM.png](Collection%20account%20Automation%20(Merchant%20layer)/Screenshot_2025-09-30_at_11.48.11_PM.png)
            
- On the currency screen , we want to show 3 fast account creation options
    - Quick Actions -
        - Virtual Accounts
            - SWIFT account in UK | CCL
            - Swift account in SG
            - Swift account in US | Fuse
        - Wallets -
            - USDT Wallet | Tron
            - USDT Wallet | Ethereum
            - USDC Wallet | Solana
            - USDC Wallet | Polygon
- Once user creates an account , a collection account id/id’s is generated , the account will start showing under Inactive accounts and a new request will be present under the account’s request tab
- Until the request is not in terminal state (failed/succeeded), merchant should be able to cancel a request.
- Under requests , add a CTA to cancel request.
- Merchant should only be allowed to  create VA/wallet if collections are allowed on their account.

## MUS8 → User wants to request for VA disablement via dashboard

### User and Objectives

- The user is any user of the Tazapay merchant dashboard with enabled collection accounts
- Their objective is to request collection account disablement from the dashboard

### Functions Requirements and Validations

- Users will see an option on the summary screen of a collection account to  `Close Account`.
- Once user clicks on this, they will see a confirmation dialog box - `Once you closed this account, you will not be able to receive any payments via this account. Make sure your account has zero balance and is not under any compliance reviews for a smooth process`.
- Once user confirms , a linked request will start showing up in the requests tab
- Once disabled on the backend , it will move under inactive tab. If account closure is rejected, it will move back to active tab.
- Wallets cannot be disabled/closed, remove the option from Ops dashboard as well. On MP dashboard as well, we will show this option only for VA and not wallets.
- If we are not able to fulfil this request , the account stays in enabled status only
- If the account is provided by CCL, we will also allow user to make a account enablement request again on the same account. The request object will have a boolean field called re_request. So we need to do soft deletes in DB while disablement so that they can be reenabled when required.(I think this already works like this, but lets verify)

## MUS9 → Build a state machine for the states of a collection account

### User and Objectives

- The user is any user of the Tazapay merchant dashboard with collection accounts
- Their objective is to be able to see the states of a VA/wallet with the timestamps and status reasons if any.

### Functions Requirements and Validations

1. User wants to be able to see the audit logs for a VA/wallet creation
2. This will include - 
    1. VA/wallet status - This can either be in active/inactive.
    2. VA/wallet account closure reason and failure reasons in case account is closed or creation failed respectively.
    3. In the requests tab , we will also build a audit log for request status tagging.
3. Copies for VA -
    1. **Active** - The collection account has been successfully activated on ‘timestamp’
    2. **Closed** - The collection account has been closed on ‘timestamp’ as <disablement reason>
4. Copies for request
    1. Created - A collection account activation/closure request has been created on ‘timestamp’
    2. Processing - The collection account activation/closure request is being processed as of ‘timestamp’
    3. Approval hold - The collection account activation/closure request is under approval hold of ‘timestamp’
    4. Requires action - The collection account activation/closure request is under requires action as of ‘timestamp’
    5. Failed - The collection account activation/closure request has failed on  ‘timestamp’ as <failure_reason>
    6. Successful - The collection account activation/closure request has succeeded on  ‘timestamp’
    

## MUS10 → Collection Account listing and detail page enhancements

### User and Objectives

- The user is any user of the Tazapay merchant dashboard
- Their objective is to check the list and details of collection accounts.

### Functions Requirements and Validations

- We will be creating 2 tabs on the collection account screen -  Active, Inactive
    - Lets show the linked BTR ids and request ids in the detail page of a collection account.
    - Requests - This tab will have further sub-tabs - Approval hold | Processing | Requires Action | Successful | Failed.
        - Details associated with a request - since the information is very less, we can just build a list , instead of a details page
        
        ```jsx
          "id":"cvar_1123/cwar_123"
          "collection_account_id":"cva_...",
        	"type":"enablement/disablement",
        	"created_at":"",
        	"updated_at":"",
        	"failure_reason":"",//only required in failed case
        	"failure_code":"", //only required in failed case
        	"disablement_reason":"" 
        ```
        
- By default , when user lands on the collection account screen , they should see Enabled account tab.
- On the detail page , along with the current collection account details we want to show
    - the status of the collection account
    - Setup fee (Both one time and yearly) and the associated balance transaction id
    - Attached documents
    - Add a new tab besides supported currencies → Linked Requests
        - Merchant should be able to filter on different status of a request.

## MUS11 → User wants to search for a collection account

### User and Objectives

- The user is any user of the Tazapay merchant dashboard with enabled collection accounts
- Their objective is to be able to search for accounts in the collection accounts list.

### Functions Requirements and Validations

- Create a search bar at the top of the collection account list
- Allow the user to search using collection account id, account name, account number and bank codes.
- Allow users to filter on currency and country.

## MUS12 → Simulate Collection account enablement and disablement on sandbox

### User and Objectives

- The user is any user of the Tazapay merchant sandbox dashboard
- Their objective is to be able to open and close collection accounts in sandbox

### Functions Requirements and Validations

1. The behaviour should be the replica of what we are going to do in production in terms of capability and behaviour.
2. In sandbox today we have 7 default static collection accounts, now we want users to be able to create dynamic accounts with all the similar capabilities as present in production today
3. Simulation for collection account requests will work as follows - 
    1. User will fill the required account details as in production, there will be an option for `Simulate Request Status`  dropdown with 3 options -  successful | failed  | processing.
    2. An account and associated request will get created according to the status
    3. On the request details page , we will have an option to ‘Simulate status` of the request which is in non terminal status as we have today in operations dashboard for payouts - ‘Manage Payouts’
    4. Simulate status will open up a dialog box to choose a status (only those status will be shown to which a request can move from it current state) and also have a description field wherever applicable, like in case of failure reason and document addition field for requires action status.
    5. The status simulations can only happen until the request is not in terminal state
    6. Once a request is in terminal state , the collection account status should change to active/inactive accordingly.

# Acceptance Criteria

1. Merchant can fetch collection account capabilities via Metadata API 
2. Merchant can create, fetch, and close collection accounts via API
3. Collection account states are tracked and exposed correctly 
4. Merchant receives webhooks and emails on state changes 
5. Dashboard supports collection account lifecycle
6. RBAC permissions control collection account access
7. Sandbox mirrors production behaviour

## Business Metrics

**North Star Metrics**

- No of collection accounts(virtual account/wallets split) created with the new flow.
- Average number of collection accounts per merchant - as the feature adoption increases , we should see quite large number of VAs for fintechs and platforms
- Increase in the total merchant balance held at Tazapay
    - Collection volume (total inflows) through these accounts over time.

**Adoption & Activation Metrics**

- Percentage of existing merchants who have integrated with the collection account API
- No of new merchants who have integrated with the collection account API
    - will help us understand if this feature is supporting in acquisition
- Time to first VA creation after a merchant goes live on the API
- Break down collection account creation into
    - Virtual accounts/wallets
        - Local/Swift
        - Domicile country
        - obo accounts/merchant accounts
            - For OBO, what are the industry verticals split , for example fintechs, platforms
        - API/Dashboard

**Funnel & Request Health Metrics**

- VA/wallet request success rate (requests reaching SUCCEEDED state)
- Request failure rate with breakdown by failure reason and provider
- Processing retry rate — a high rate signals provider reliability issues
- Requires action rate — signals document/ops bottlenecks. If there is a particular type of document that is always being requested , we can ask for it upfront.
- Average time from request creation to terminal state (SUCCEEDED or FAILED)
- Cancellation rate before terminal state

**API & Platform Health**

- Metadata API latency
- Error rate on POST /v3/collection_account for unsupported capability requests — a high rate means merchants aren't consuming the metadata API correctly before attempting creation

**Fee & Revenue Metrics** 

- Total net revenue from fees.
- Number of accounts reaching annual renewal (measuring retention of enabled accounts)

**Sandbox Simulation**

- Sandbox simulation usage rate - avg no of test collection accounts have been created in sandbox for a user
- Average no of request state simulations for a VA

# Appendix

## OPS2 → Add a temporary disable option on ops dashboard when they are disabling a VA

### User and Objectives

- The user is any user of the Tazapay operations dashboard
- Their objective is to allow temporary disable of accounts on ops dashboard which they can enable later.

### Functions Requirements and Validations

- As of today, on operations dashboard , user cannot disable account temporarily. This is required when providers disable accounts temporarily on their end when that account is under some investigation.In this case , operations needs to disable account permanently on the dashboard and then create a account again once investigations are closed on providers end
- When user clicks on disable toggle on ops dashboard , we need to show a confirmation dialog box with two options - permanently disable and temporarily disable.
- For temporarily disabled accounts , there should be a option to enable them back.
- We will also show any permanently or temporary disabled on the timeline in merchant dashboard.
- **Open Question** - @Amit Kumar Tiwari Do our providers give us an option to temporarily disable by choice, or this only happens when there is some investigation etc on an account. Accordingly we can decide if we want to expose this option on MP dashboard.

## Approval Based VA config

1. Config to allow Collection or not.
2. Config to not allow VA creation for all merchants - how is this diff from config 1. Or are we saying that we want to give VAs but since it is a high risk merchant we will evaluate before giving each VA and hence will not allow customer to request VAs.
3.    For those , we have turned on VA request - rules will apply 
4. compliance can set rules separately for each merchant as well if they want to deny a particular country ccy pair while onboarding
5. Lets show the users options to request the denied VA’s as well, but once they click on submit , we can show them a error that. they cannot request this due to ‘Reason’ instead of passing the request to the ops team

Ranking of VA providers 

## Dashboard

## **Objective**

To evaluate VA creation capabilities via dashboard and API across key competitors and identify gaps/opportunities for product improvement.”

## **Analyses**

| Feature / Provider | **Airwallex** | **Payoneer** | **Column Bank** | **Freemarket** |  **CCL** |
| --- | --- | --- | --- | --- | --- |
| **Virtual Account Offering** | Yes – Multiple-currency virtual accounts (Local + SWIFT) | Yes – Global receiving accounts (local + SWIFT) | Yes – Offers virtual accounts via API to fintechs | Yes – FX-enabled accounts with named virtual IBANs |  Multi-currency wallets with some named accounts |
| **Currency Support** | 11+ currencies including USD, EUR, GBP, AUD, SGD, HKD, CNY | 10+ currencies (USD, EUR, GBP, JPY, AUD, etc.) | USD primarily; non-USD depends on partner banks | EUR, GBP, USD, CAD, CHF, HKD, JPY, AUD | 30+ (USD, EUR, GBP, SGD, CAD, JPY, etc.) |
| **Named Accounts** | Yes – With unique account numbers | Yes – In your name (e.g., USD via Community Federal) | Yes – Named accounts via API | Yes – Named IBANs in your name | yes |
| **APIs** | Yes – Full stack banking API incl. VA creation | No public API for VA creation (partner-only) | Yes – Developer-first with RESTful API | APIs available but may require qualification | Could not find API to request a collection account |
| **Speed of Account Creation** | Near instant via API or dashboard | Manual review involved; may take 24–72 hours | Real-time (API-based onboarding for fintechs) | Within 24–48 hrs post-KYC | Instantly for a onboarded customer(but can Depends on currency) |

## Key Insights/Adoption

1. Add domicile country as a input while requesting a VA
2. Add a nick name for easy identification of the account
3. Push for 24-48 hrs of VA approval wherever possible
4. Support multi currency in same account, today not many competitors give this via api’s today

## VA creation processes

### Airwallex

Dashboard - https://help.airwallex.com/hc/en-gb/articles/900001756146-Creating-and-Viewing-Global-Accounts

Api - [https://www.airwallex.com/docs/api#/Core_Resources/Global_Accounts/_api_v1_global_accounts_create/post](https://www.airwallex.com/docs/api#/Core_Resources/Global_Accounts/_api_v1_global_accounts_create/post)

Airwallex supports VA creation by both dashboard and Api. 

### CCL

1. Once user is onboarded on the platform , they are only required to add currency to onboard a new account 
    
    ![Screenshot 2025-04-07 at 12.14.24 PM.png](Collection%20account%20Automation%20(Merchant%20layer)/Screenshot_2025-04-07_at_12.14.24_PM.png)
    
2. CCL provides account in the requested currency for all transfer types. 
    
    ![Screenshot 2025-04-07 at 12.15.35 PM.png](Collection%20account%20Automation%20(Merchant%20layer)/Screenshot_2025-04-07_at_12.15.35_PM.png)
    
3.  Account is created instantly after requesting for a currency.

### SCB

1. SCB follows a maker checker process.
2. VA’s are created as sub accounts under a master account.
3. For sub-account, all the details need to be filled like Name , address , country etc 
4. Once all the details are filled, VA needs to be approved by a user that has approval permissions.

## currencies approaches for VA

1. For currencies, we have three options -
    1. **Option 1** - We will show a list of currency pairs that can be supported in a single account from all the applicable providers. For example , one provider can support USD and EUR , another provider can support USD , EUR and GBP and another provider only supports single currency per account . Then we will show 5 different options - 
        - USD , EUR , GBP
        - USD , EUR
        - USD
        - GBP
        - EUR
    - We will also give a filter option to filter out currencies.
    - User can select multiple options to request for multiple VAs in one go.
    - When user clicks on each option , we want to expand a block that shows what are the transfer types available - SWIFT , LOCAL , under local what all networks are available. What is the usual time taken by each network. Similar to the one below.
        
        ![Screenshot 2025-05-27 at 4.12.47 PM.png](Collection%20account%20Automation%20(Merchant%20layer)/Screenshot_2025-05-27_at_4.12.47_PM.png)
        
        **Pros** - This approach helps user to understand what capabilities a particular account can provide upfront.
        
        We will enable all currencies in one go for the user , hence there will be less operational burden on both merchant’s and TP’s end in case of multi ccy account. 
        
        **Cons** - This might not the best user experience as user might be confused because there are multiple options that provide EUR. 
        
    1. Option 2 - 
        - We will show user the list of currencies in which we support VAs accross all providers for the selected domicile
        - We do not let them select currencies, but enable multiple currencies for them provided in that domicile accross multiple providers
        - Pros - This a cleaner flow and a one step process for user to choose the country for the account and review ccy info
        - Cons - This reduces flexibility on users end as he might
            - Not want to provision so many ccy and pay the setup fees for multiple accounts
            - Want to specify if he wants a multi ccy or a single ccy account if given an option
        
        Given the pros and cons, we will go with option 1.
        
    
    Below is the Airwallex experience for design inspiration. 
    

# Competitive Analysis

## API Specs

### Airwallex Metadata (**check [https://demo.airwallex.com/graphql/globalaccount/GetNewAccountSettingRules](https://demo.airwallex.com/graphql/globalaccount/GetNewAccountSettingRules)** )

**check for location as DK, HK, US - they will cover all different types of cases.**

```json
{
    "data": {
        "globalAccountSettingRules": [
            {
                "location": "AU",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "ANZ_OS_BSB",
                        "supportedCurrencies": [
                            {
                                "currency": "AUD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "Bank",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": null,
                                            "localClearingSystemDisplayName": null,
                                            "supported": false,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [
                                        {
                                            "localClearingSystemDisplayName": "BECS",
                                            "mandateManageable": false,
                                            "supported": true,
                                            "__typename": "GlobalAccountSupportedCurrencyDirectDebitCapability"
                                        }
                                    ],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "GB",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "CLEARBANK_AWXUK",
                        "supportedCurrencies": [
                            {
                                "currency": "GBP",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "Faster Payments",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "CHAPS",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "1-2",
                                            "localClearingSystemDisplayName": "BACS",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [
                                        {
                                            "localClearingSystemDisplayName": "Bacs",
                                            "mandateManageable": true,
                                            "supported": true,
                                            "__typename": "GlobalAccountSupportedCurrencyDirectDebitCapability"
                                        }
                                    ],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "NL",
                "asEU": true,
                "options": [
                    {
                        "vbaProvider": "LHV_NL_AGENCY",
                        "supportedCurrencies": [
                            {
                                "currency": "EUR",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-2",
                                            "localClearingSystemDisplayName": "SEPA",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "SEPA Instant",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "TARGET2",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": null,
                                            "localClearingSystemDisplayName": null,
                                            "supported": false,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [
                                        {
                                            "localClearingSystemDisplayName": "SEPA",
                                            "mandateManageable": false,
                                            "supported": true,
                                            "__typename": "GlobalAccountSupportedCurrencyDirectDebitCapability"
                                        }
                                    ],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "DK",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "SAXO",
                        "supportedCurrencies": [
                            {
                                "currency": "DKK",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "Intradagclearing",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "KRONOS2",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "Straksclearing",
                                            "supported": false,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "EUR",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-2",
                                            "localClearingSystemDisplayName": "SEPA",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "SEPA Instant",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "TARGET2",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "AED",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "AUD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "CAD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "CHF",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "CNY",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "CZK",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "GBP",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "HKD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "HUF",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "ILS",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "JPY",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "MXN",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "NOK",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "NZD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "PLN",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "RON",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "SEK",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "SGD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "USD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "ZAR",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "EE",
                "asEU": true,
                "options": [
                    {
                        "vbaProvider": "LHV",
                        "supportedCurrencies": [
                            {
                                "currency": "EUR",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-2",
                                            "localClearingSystemDisplayName": "SEPA",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "SEPA Instant",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "TARGET2",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": null,
                                            "localClearingSystemDisplayName": null,
                                            "supported": false,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "DE",
                "asEU": true,
                "options": [
                    {
                        "vbaProvider": "SAXO",
                        "supportedCurrencies": [
                            {
                                "currency": "EUR",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-2",
                                            "localClearingSystemDisplayName": "SEPA",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "SEPA Instant",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "TARGET2",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": null,
                                            "localClearingSystemDisplayName": null,
                                            "supported": false,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "HK",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "SCB",
                        "supportedCurrencies": [
                            {
                                "currency": "HKD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "1-2",
                                            "localClearingSystemDisplayName": "ACH",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "RTGS",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "FPS",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    },
                    {
                        "vbaProvider": "SCB",
                        "supportedCurrencies": [
                            {
                                "currency": "CNY",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "1-2",
                                            "localClearingSystemDisplayName": "ACH",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "RTGS",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "FPS",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    },
                    {
                        "vbaProvider": "SCB",
                        "supportedCurrencies": [
                            {
                                "currency": "USD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "RTGS",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    },
                    {
                        "vbaProvider": "SCB",
                        "supportedCurrencies": [
                            {
                                "currency": "EUR",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "RTGS",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    },
                    {
                        "vbaProvider": "SCB",
                        "supportedCurrencies": [
                            {
                                "currency": "AUD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    },
                    {
                        "vbaProvider": "SCB",
                        "supportedCurrencies": [
                            {
                                "currency": "CAD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    },
                    {
                        "vbaProvider": "SCB",
                        "supportedCurrencies": [
                            {
                                "currency": "CHF",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    },
                    {
                        "vbaProvider": "SCB",
                        "supportedCurrencies": [
                            {
                                "currency": "GBP",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    },
                    {
                        "vbaProvider": "SCB",
                        "supportedCurrencies": [
                            {
                                "currency": "JPY",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    },
                    {
                        "vbaProvider": "SCB",
                        "supportedCurrencies": [
                            {
                                "currency": "NZD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    },
                    {
                        "vbaProvider": "SCB",
                        "supportedCurrencies": [
                            {
                                "currency": "SGD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "US",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "CFSB",
                        "supportedCurrencies": [
                            {
                                "currency": "USD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "1-2",
                                            "localClearingSystemDisplayName": "ACH",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "Fedwire",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [
                                        {
                                            "localClearingSystemDisplayName": "ACH",
                                            "mandateManageable": false,
                                            "supported": true,
                                            "__typename": "GlobalAccountSupportedCurrencyDirectDebitCapability"
                                        }
                                    ],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "SG",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "DBS_SG_STATIC",
                        "supportedCurrencies": [
                            {
                                "currency": "SGD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "FAST",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "MEPS",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "1-2",
                                            "localClearingSystemDisplayName": "GIRO",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "USD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "AUD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "CAD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "CHF",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "CNY",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "EUR",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "GBP",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "HKD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "JPY",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "NOK",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "NZD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            },
                            {
                                "currency": "SEK",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-3",
                                            "localClearingSystemDisplayName": null,
                                            "supported": true,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "CA",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "DCB_AWXCA",
                        "supportedCurrencies": [
                            {
                                "currency": "CAD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "EFT",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "Interac e-Transfer",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": null,
                                            "localClearingSystemDisplayName": null,
                                            "supported": false,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [
                                        {
                                            "localClearingSystemDisplayName": "EFT",
                                            "mandateManageable": false,
                                            "supported": true,
                                            "__typename": "GlobalAccountSupportedCurrencyDirectDebitCapability"
                                        }
                                    ],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "NZ",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "ANZ_NZ",
                        "supportedCurrencies": [
                            {
                                "currency": "NZD",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "Bank",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": null,
                                            "localClearingSystemDisplayName": null,
                                            "supported": false,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "ID",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "SCBID_AWXHK",
                        "supportedCurrencies": [
                            {
                                "currency": "IDR",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "SKN",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "RTGS",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "BI-FAST",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "ATM PRIMA",
                                            "supported": false,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": null,
                                            "localClearingSystemDisplayName": null,
                                            "supported": false,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "AE",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "SCBAE_AWXHK",
                        "supportedCurrencies": [
                            {
                                "currency": "AED",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "IPI",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "RTGS",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": null,
                                            "localClearingSystemDisplayName": null,
                                            "supported": false,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "MX",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "MEXPAGOMX_AWXMX",
                        "supportedCurrencies": [
                            {
                                "currency": "MXN",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "SPEI",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": null,
                                            "localClearingSystemDisplayName": null,
                                            "supported": false,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "IL",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "BOJIL_AWXUK",
                        "supportedCurrencies": [
                            {
                                "currency": "ILS",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "Faster Payments",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "MASAV",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "ZAHAV",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": null,
                                            "localClearingSystemDisplayName": null,
                                            "supported": false,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            },
            {
                "location": "PH",
                "asEU": false,
                "options": [
                    {
                        "vbaProvider": "DRAGONPAY_AWXSG",
                        "supportedCurrencies": [
                            {
                                "currency": "PHP",
                                "capabilities": {
                                    "deposit": [
                                        {
                                            "depositSpeed": "0-1",
                                            "localClearingSystemDisplayName": "InstaPay",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": "0-2",
                                            "localClearingSystemDisplayName": "PESONet",
                                            "supported": true,
                                            "paymentMethod": "LOCAL",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        },
                                        {
                                            "depositSpeed": null,
                                            "localClearingSystemDisplayName": null,
                                            "supported": false,
                                            "paymentMethod": "SWIFT",
                                            "__typename": "GlobalAccountSupportedCurrencyDepositCapability"
                                        }
                                    ],
                                    "directDebit": [],
                                    "__typename": "GlobalAccountSupportedCurrencyCapabilities"
                                },
                                "__typename": "GlobalAccountSupportedCurrency"
                            }
                        ],
                        "__typename": "GlobalAccountSettingRuleOption"
                    }
                ],
                "__typename": "GlobalAccountSettingRule"
            }
        ]
    }
}
```

## Airwallex account creation

Request

```json
{
    "country_code": "HK",
    "nick_name": "My New Global Account",
    "required_features": [
          {
            "currency": "CNY",
            "transfer_method": "LOCAL"
        }
    ],
    "request_id": "{{$guid}}"
}
```

Response

```json
{
    "account_name": "Sandbox Business",
    "account_number": "47404000139",
    "account_type": "Current",
    "country_code": "HK",
    "id": "95505de6-6a56-4ffc-8c3c-14042a87ede9",
    "institution": {
        "address": "32nd Floor, 4-4A Des Voeux Road Central",
        "city": "Hong Kong SAR",
        "name": "Standard Chartered Bank (Hong Kong) Ltd"
    },
    "nick_name": "My New Global Account",
    "request_id": "0c49d6b0-0680-489c-b725-a328eb44ac99",
    "required_features": [
        {
            "currency": "CNY",
            "transfer_method": "LOCAL"
        }
    ],
    "status": "ACTIVE",
    "supported_features": [
        {
            "currency": "CNY",
            "local_clearing_system": "ACH",
            "routing_codes": [
                {
                    "type": "bank_code",
                    "value": "003"
                },
                {
                    "type": "branch_code",
                    "value": "474"
                }
            ],
            "transfer_method": "LOCAL",
            "type": "DEPOSIT"
        },
        {
            "currency": "CNY",
            "local_clearing_system": "RTGS",
            "routing_codes": [
                {
                    "type": "bank_code",
                    "value": "003"
                },
                {
                    "type": "branch_code",
                    "value": "474"
                }
            ],
            "transfer_method": "LOCAL",
            "type": "DEPOSIT"
        },
        {
            "currency": "CNY",
            "local_clearing_system": "FPS",
            "routing_codes": [
                {
                    "type": "bank_code",
                    "value": "003"
                },
                {
                    "type": "branch_code",
                    "value": "474"
                }
            ],
            "transfer_method": "LOCAL",
            "type": "DEPOSIT"
        },
        {
            "currency": "CNY",
            "routing_codes": [
                {
                    "type": "bank_code",
                    "value": "003"
                },
                {
                    "type": "branch_code",
                    "value": "474"
                },
                {
                    "type": "swift",
                    "value": "SCBLHKHH"
                }
            ],
            "transfer_method": "SWIFT",
            "type": "DEPOSIT"
        }
    ],
    "swift_code": "SCBLHKHH"
}
```

## [**Metrics Tracking**](https://www.notion.so/Collection-account-Automation-metrics-335c765b7248809ba5f3d7fe2e686734?pvs=21)