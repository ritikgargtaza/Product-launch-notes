# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Settlement Orchestration is a Go-based service that manages and streamlines settlement processes for financial transactions. It integrates with multiple Payment Service Providers (PSPs) and provides a robust framework for handling remittances, payouts, and webhook processing.

## Dependencies

This service depends on the `grpc-framework` repository, which must be placed in the same parent directory. The framework provides shared build tools, configurations, and common functionality.

## Development Commands

### Essential Commands

- `make` - View available commands and descriptions
- `make build` - Compile the service
- `make run` - Run the service locally (uses ports 5000 for gRPC, 7000 for HTTP)
- `make pr-ready` - Prepare code for production (runs mod, build, lint, security, cover)
- `make update-dep` - Update Go dependencies to latest versions

### Testing

- `make unit-test` - Run all unit tests
- `make cover` - Generate test coverage report (minimum 90% required)
- `go test -v -run TestFunctionName ./path/to/package` - Run a single test
- Coverage reports are generated in `coverage.html` and `coverage.txt`

### Code Quality

- `make lint` - Run linting checks using golangci-lint
- `make security` - Run security checks using gitleaks
- `make mod` - Tidy Go modules

### Database

- Database migrations are in `migration/postgres/`
- Run migrations: `migrate -source file://migration/postgres -database "postgres://postgres:postgres@127.0.0.1:5432/settlement_orchestration?sslmode=disable" up`

## Architecture

### Core Components

**Service Layers:**

- `service/grpc/v1/` - gRPC service implementations (balance, payouts, remittance, customer creation)
- `service/http/v3/` - HTTP webhook handlers for various PSPs
- `service/scheduler/` - Cron job scheduler for automated tasks

**Client Integration:**

- `client/api/` - PSP client implementations: BankingCircle, BCA, BVNK, CCL, CPN-OFI, DBS, JPMorgan, Lightspark, Notabene, Ripple, SCB, Unlimit, WePayments, Xendit, YesBank
- Each PSP has its own subdirectory with API client, initiation logic, and tests

**Data Layer:**

- `repository/` - Database repository interfaces and implementations
- `pgx/` - PostgreSQL database interactions using pgx driver
- `model/` - Database models and structures

**Core Infrastructure:**

- `constants/` - System constants organized by PSP and functionality
- `types/` - Custom type definitions for different PSPs and operations
- `response/` - Standardized error responses and codes
- `utils/` - Helper utilities for common operations
- `validate/` - Custom validators for PSP-specific business rules
- `tools/` - Shared utility packages: `decimal` (precision arithmetic), `queue` (SQS helpers), `slack` (alerting), `generator` (ID generation)
- `env/` - Per-environment YAML configs: `sandbox`, `preprod`, `prod`, `drpreprod`, `drprod`, plus color-coded canary environments (`amber`, `brown`, `indigo`, `orange`, `purple`, `yellow`)

### PSP Integration Pattern

Each PSP follows a consistent structure:

- API client (`api.go`)
- Initiation logic (`initiate.go`)
- PSP-specific types and constants
- Comprehensive unit tests (`*_test.go`)
- Status and error mapping utilities

### Error Handling

- PSP-specific errors in `psperror/`
- Status mapping in `pspstatus/`
- Standardized error responses in `response/`

## Testing Strategy

- **Unit Tests**: Located alongside source files (`*_test.go`)
- **Mocks**: Generated mocks in `mocks/` directory for repositories and services
- **Test Data**: Sample data in `testdata/` directory
- **Coverage**: Minimum 90% test coverage required
- **Integration**: Tests cover PSP integrations and webhook processing

## Key Patterns

### Service Structure

The service runs multiple concurrent servers:

- gRPC server (port 5000)
- HTTP gateway server (port 7000)
- Cron scheduler for automated tasks (status checks for BCA, BankingCircle, JPMorgan, Ripple, YesBank)
- SQS listener (event-driven payout processing, travel rule enforcement)
- Profiler server

### Repository Pattern

- Interfaces defined in `repository/intf/`
- Implementations in `pgx/` and `postgres/`
- Mock implementations for testing

### PSP Client Pattern

Each PSP client implements:

- Initiation methods for payouts/remittances
- Status checking capabilities
- Error handling and mapping
- Webhook processing

## Development Notes

### Code Quality Standards

- Follow Go best practices and the patterns established in existing code
- All PSP integrations should follow the established client pattern
- Maintain comprehensive test coverage (90%+ required)
- Use the grpc-framework for shared utilities and configurations
- Database changes require migration scripts in `migration/postgres/`
- Use structured logging with `lower_snake_case` keys

### Common Patterns to Follow

- **Error Handling**: Always log errors with context, record in traces, and use standardized responses
- **Logging**: Use `logger.FromContext(ctx).With(ctx, "key", value)` with snake_case keys
- **Transactions**: Use `repository.Pgx().BeginTx(ctx)` for multi-operation transactions
- **Context**: Pass context through all function calls, use errgroup context in goroutines
- **Validation**: Custom validators for complex PSP-specific rules, standard validators for simple cases

## Environment Setup

- Requires Go 1.24+
- PostgreSQL database for local development
- Redis for caching
- AWS services (SQS, etc.) for queue management
- Docker setup available through grpc-framework
