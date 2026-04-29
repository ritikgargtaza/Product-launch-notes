# Settlement Orchestration

Welcome to the Settlement Orchestration Repository!

This README provides an overview of the contents and structure of the codebase. Whether you're a new contributor, or team member, or just exploring the code, this guide will help you navigate through the different sections of the project.

## Overview

The **settlement orchestration** service is a comprehensive system designed to manage and streamline the settlement processes for various financial transactions. It integrates with multiple payment service providers (PSPs) and offers a robust framework for handling remittances, payouts, and webhook processing. The service is built using Go and leverages several third-party libraries and frameworks to ensure reliability, scalability, and maintainability.It integrates with multiple other services to ensure a seamless and efficient payout processing experience for merchants.

## Getting Started

- Install `Go` and confirm it is executable.  
- Clone the [grpc-framework](https://github.com/tazapay/grpc-framework) repository to your local machine.  
- Clone the settlement orchestration repository locally.  
- Ensure both the framework and service are placed under the same parent directory.  
- Run the `make` command without arguments to view available commands and their descriptions.  
- Reach out to your colleague to obtain the local environment file.  
- Use the one-time [Docker setup](https://github.com/tazapay/grpc-framework/tree/main/docker/local) to configure the service locally for an improved development experience.  
- Execute the following command to apply database migrations to your local Docker setup.

```shell
migrate -source file://migration/postgres -database "postgres://postgres:postgres@127.0.0.1:5432/settlement_orchestration?sslmode=disable" up
```

## Know More about Settlement Orchestration

Refer the following sections to know more about the service.

- [Key Capabilities](/docs/key_capabilities.md)
- [Code Structure](/docs/code_structure.md)
- [Database](/docs/database.md)
- [Endpoints](/docs/endpoints.md)
- [Testing](/docs/testing.md)

## Contributions

To contribute code changes, follow these guidelines:

- Follow the official Go code style. Refer to [Effective Go](https://go.dev/doc/effective_go) for best practices.
- Use meaningful and descriptive names for variables and functions.
- Write clear and concise comments explaining the purpose and behavior of your code.
- Ensure test coverage is at least **90%**. Use the `make cover` command to generate a coverage report.
- Run `make lint` to resolve any linting issues before submitting a pull request.
- Keep pull requests scoped to a single change or feature. Before pushing commits, run `make pr-ready`, which automatically handles `mod`, `build`, `lint`, `security`, `cover`, etc checks.
- Incorporate AI feedback and suggestions provided by the LLM powered PR-Agent.
- Pass the build to QA only after securing at least one approval.
- Obtain a minimum of two approvals before merging the pull request.
- Deploy the service to any environment using [GitHub Actions](.github/workflows/cd.yml).

---

Thank you for checking out our repository! Happy coding!!!
