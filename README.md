# Ephemeral Database Example

## Overview

This repository demonstrates a modern approach to development and testing environments using ephemeral databases. It showcases how to set up and use containerized, ephemeral instances of PostgreSQL and DynamoDB for development, testing, and demonstration purposes.

## Purpose

The primary goals of this project are:

1. **Improved Developer Experience (DevEx)**: Provide developers with easy-to-use, consistent database environments that can be quickly created and destroyed.
2. **Reliable Testing**: Enable reliable, repeatable testing by ensuring tests always run against a clean, known database state.
3. **Simplified Onboarding**: Reduce the time and complexity for new team members to set up a working environment.
4. **Portable Demonstrations**: Create a self-contained application that can be easily demonstrated without external dependencies.

## What Are Ephemeral Databases?

Ephemeral databases are temporary database instances that:
- Are created on demand
- Start with a predefined schema and sample data
- Exist only for the duration of a development session, test run, or demonstration
- Are destroyed when no longer needed, leaving no persistent state

This approach eliminates issues like:
- "Works on my machine" problems
- Test failures due to accumulated or inconsistent data
- Complex database setup procedures
- Dependency on external database services

## Project Structure

```
ephemeral-db-example/
├── airline-backend-java/           # Main application
│   ├── db/                         # Database configurations
│   │   ├── postgres/               # PostgreSQL configuration
│   │   │   ├── init/               # Initialization scripts
│   │   │   │   ├── 01_extensions.sql
│   │   │   │   ├── 02_schema.sql
│   │   │   │   └── 03_sample_data.sql
│   │   │   ├── Dockerfile          # PostgreSQL container definition
│   │   │   ├── docker-compose.yml  # Standalone PostgreSQL setup
│   │   │   └── README.md           # PostgreSQL-specific documentation
│   │   │
│   │   └── dynamodb/               # DynamoDB configuration
│   │       ├── Dockerfile          # DynamoDB container definition
│   │       ├── docker-compose.yml  # Standalone DynamoDB setup
│   │       ├── init-local-db.sh    # DynamoDB initialization script
│   │       └── README.md           # DynamoDB-specific documentation
│   │
│   ├── src/                        # Application source code
│   │   ├── main/
│   │   │   ├── java/com/example/airline/
│   │   │   │   ├── config/         # Database configuration classes
│   │   │   │   ├── controller/     # REST API controllers
│   │   │   │   ├── model/          # Entity models
│   │   │   │   ├── repository/     # Data access repositories
│   │   │   │   └── service/        # Business logic services
│   │   │   │
│   │   │   └── resources/          # Application resources
│   │   │       ├── application.yml # Application configuration
│   │   │       └── db/init/        # Additional DB scripts
│   │   │
│   │   └── test/                   # Test code
│   │
│   ├── Dockerfile                  # Application container definition
│   ├── docker-compose.yml          # Complete application stack setup
│   ├── pom.xml                     # Maven dependencies
│   ├── test-endpoints.sh           # Test script for API validation
│   └── README.md                   # Application-specific documentation
│
└── dynamodb-local/                 # Standalone DynamoDB Local setup
    ├── Dockerfile                  # DynamoDB container definition
    ├── docker-compose.yml          # Standalone setup
    ├── init-local-db.sh            # Initialization script
    └── README.md                   # Usage documentation
```

## Key Components

### 1. Spring Boot REST API

The application is built using Spring Boot 3.2.3 with Java 17 and demonstrates:
- REST API implementation with proper controller/service/repository layers
- Integration with both relational (PostgreSQL) and NoSQL (DynamoDB) databases
- Comprehensive error handling and response formatting
- Proper API documentation

### 2. PostgreSQL Database (PGAir)

The PostgreSQL database:
- Uses PostGIS extension for geospatial data
- Runs in an ephemeral container with tmpfs for in-memory storage
- Includes initialization scripts for schema and sample data
- Demonstrates airline domain entities (flights, aircraft, bookings, etc.)

### 3. DynamoDB Local

The DynamoDB Local setup:
- Provides a local, containerized version of AWS DynamoDB
- Includes initialization scripts for creating tables and sample data
- Demonstrates integration with AWS SDK
- Shows how to work with NoSQL data models

### 4. Testing and Validation

The repository includes:
- A comprehensive test script (`test-endpoints.sh`) to validate API functionality
- Automated infrastructure setup and teardown
- Sample data initialization
- Clear output of test results

## Getting Started

Each component includes its own README with specific instructions, but the general workflow is:

1. Clone the repository
2. Run `docker-compose up -d` in the main directory
3. Wait for all services to initialize
4. Access the API at http://localhost:8080/api/v1/
5. Run the test script with `./test-endpoints.sh` to validate functionality

## Development Workflow

The recommended development workflow is:

1. Start the ephemeral databases using Docker Compose
2. Run the application locally for development
3. Make changes to the code
4. Test against the ephemeral databases
5. When finished, tear down the environment with `docker-compose down -v`

## Benefits Demonstrated

This example showcases several benefits:

1. **Consistency**: Every developer works with the same database setup
2. **Isolation**: Changes made during testing don't affect other developers
3. **Speed**: No need to restore databases or clean up test data
4. **Simplicity**: Easy setup and teardown with Docker Compose
5. **Portability**: The entire stack can run on any machine with Docker

## Technologies Used

- Java 17
- Spring Boot 3.2.3
- PostgreSQL with PostGIS
- DynamoDB Local
- Docker & Docker Compose
- Maven
- Bash scripting

## Best Practices Demonstrated

This repository demonstrates several best practices:

1. **Separation of Concerns**: Database setup is separated from application code
2. **Infrastructure as Code**: All infrastructure is defined in Docker Compose files
3. **Automation**: Scripts automate setup, testing, and teardown
4. **Documentation**: Each component is well-documented
5. **Sample Data**: Realistic sample data is provided for testing and demos
