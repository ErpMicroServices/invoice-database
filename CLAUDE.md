# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this module.

## Module Overview

The `invoice-database` module manages database schema and data for the invoicing and billing domain of the ERP system. This module handles invoice creation, payment tracking, billing cycles, and financial reconciliation, using Liquibase for schema migrations and Docker for containerization.

## Technology Stack

- **Database**: PostgreSQL
- **Migration Tool**: Liquibase
- **Container**: Docker
- **Package Manager**: npm
- **Testing**: Cucumber.js with BDD approach
- **Test Database**: pg-promise for database connections

## Project Structure

```
invoice-database/
├── Dockerfile                    # Database container configuration
├── database_change_log.yml       # Liquibase main changelog
├── package.json                 # Node.js dependencies and scripts
├── package-lock.json            # Exact dependency versions
├── sql/                         # Database initialization scripts
│   ├── 01-install-extensions.sql
│   ├── 02-create-database.sql
│   └── 03-initial-data.sql
└── features/                    # BDD test specifications
    ├── step_definitions/
    │   └── hooks.js
    └── support/
        ├── chai.js
        ├── config.js
        ├── database.js
        └── world.js
```

## Build and Development Commands

### Database Operations
```bash
# Install dependencies
npm install

# Build database schema (offline)
npm run build:database

# Build Docker container
npm run build:docker

# Apply database changes to running database
npm run update_database

# Start database container
npm run start

# Push container to registry
npm run push

# Clean up build artifacts and containers
npm run clean
```

### Testing
```bash
# Run BDD tests for invoice database
npm test
```

## Invoice Domain Features

### Invoice Management
- **Invoice Creation**: Generate invoices from orders or services
- **Invoice Status**: Draft, sent, paid, overdue, cancelled states
- **Invoice Types**: Standard, credit memo, debit memo, recurring invoices
- **Line Items**: Detailed billing with products, services, taxes, and discounts

### Payment Processing
- **Payment Tracking**: Record and track customer payments
- **Payment Methods**: Cash, check, credit card, ACH, wire transfer support
- **Payment Status**: Pending, processing, completed, failed, refunded
- **Partial Payments**: Handle multiple payments against single invoices

### Billing and Collections
- **Billing Cycles**: Monthly, quarterly, annual billing schedules
- **Recurring Billing**: Automatic invoice generation for subscriptions
- **Collections Management**: Overdue tracking and collection workflows
- **Payment Terms**: Net 30, net 60, custom payment terms

### Financial Integration
- **General Ledger Integration**: Automatic journal entry creation
- **Tax Management**: Sales tax, VAT, and other tax calculations
- **Currency Support**: Multi-currency invoicing and conversion
- **Financial Reporting**: Aging reports, revenue recognition, cash flow

## Development Workflow

### Invoice Schema Management
1. **Business Requirements**: Understand invoicing and payment workflows
2. **Compliance Needs**: Consider tax regulations and financial reporting requirements
3. **Create Changesets**: Add Liquibase changesets for invoice schema updates
4. **Integration Points**: Ensure compatibility with accounting and payment systems
5. **Test Scenarios**: Create comprehensive BDD tests for invoice processes
6. **Performance Testing**: Validate query performance for high-volume scenarios

### Key Database Components

#### Core Invoice Tables
- **invoice**: Main invoice header information
- **invoice_line_item**: Detailed line items for products/services
- **invoice_status**: Invoice lifecycle tracking
- **payment**: Payment records and associations
- **payment_method**: Supported payment types and configurations

#### Financial Integration Tables
- **tax_calculation**: Tax computation and breakdown
- **currency_conversion**: Multi-currency support
- **accounting_entry**: General ledger integration
- **billing_schedule**: Recurring billing configurations

## Testing Standards

### Invoice BDD Testing
- **Invoice Lifecycle**: Creation, modification, approval, payment scenarios
- **Payment Processing**: Various payment methods and failure scenarios
- **Billing Automation**: Recurring billing and schedule management
- **Financial Accuracy**: Tax calculations, currency conversions, accounting integration
- **Collections Process**: Overdue handling and collection workflow testing

### Compliance Testing
- **Tax Compliance**: Verify tax calculations meet regulatory requirements
- **Financial Reporting**: Ensure accurate financial data for reporting
- **Audit Trail**: Complete audit trail for all invoice and payment activities
- **Security**: Access controls and sensitive financial data protection

## Docker Integration

The module produces a Docker container named `erpmicroservices/invoice-database` that:
- Extends PostgreSQL base image
- Initializes invoice database schema with appropriate indexes
- Includes reference data for invoice processes (tax rates, payment methods)
- Supports high-volume invoice processing and reporting
- Integrates with accounting and payment processing services

## Dependencies and Requirements

### Runtime Dependencies
- PostgreSQL database server (12+ recommended)
- Docker (for containerized deployment)
- Liquibase (managed through npm scripts)

### Development Dependencies
- Node.js and npm
- Cucumber.js testing framework
- Chai assertion library
- pg-promise for database connectivity

## Performance Considerations

### Invoice Processing Optimization
- **High Volume Support**: Efficient handling of large invoice batches
- **Payment Processing**: Fast payment recording and reconciliation
- **Reporting Performance**: Optimized queries for financial reports
- **Search Capabilities**: Fast invoice search by various criteria

### Database Optimization
- **Indexing Strategy**: Indexes on customer, date, status, and amount fields
- **Partitioning**: Table partitioning for high-volume invoice data
- **Archiving**: Data retention and archiving strategies
- **Backup Recovery**: Point-in-time recovery for financial data

## Integration Points

### ERP System Integration
- **Order Management**: Invoice generation from sales orders
- **Inventory Management**: Product and service information
- **Customer Management**: Customer and billing address information
- **Accounting Integration**: General ledger and financial reporting

### External System Integration
- **Payment Gateways**: Credit card and electronic payment processing
- **Banking Systems**: ACH, wire transfers, and bank reconciliation
- **Tax Services**: Automated tax calculation and compliance
- **Document Management**: Invoice PDF generation and storage

## Important Notes

- **Financial Accuracy**: Critical for business financial operations
- **Compliance Requirements**: Must meet tax and financial reporting regulations
- **Security Critical**: Handles sensitive financial and customer data
- **Audit Trail Essential**: Complete tracking for compliance and dispute resolution
- **Performance Sensitive**: High-volume processing requirements
- **Integration Heavy**: Connects with many other business systems