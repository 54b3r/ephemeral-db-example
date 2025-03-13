# Ephemeral DynamoDB Local Database

This directory contains a portable, ephemeral DynamoDB Local database configuration for development and testing purposes.

## Features

- **Ephemeral Storage**: Runs with the `-inMemory` flag to store all data in memory, ensuring a clean state on each restart
- **Self-Contained**: Includes AWS CLI and initialization scripts within the container
- **Automatic Initialization**: Creates required tables and loads sample data on startup
- **Portable Configuration**: Can be used independently or as part of the main application

## Usage

### Standalone Mode

To run the DynamoDB Local database independently:

```bash
cd db/dynamodb
docker-compose up -d
```

This will start a DynamoDB Local instance with the following configuration:
- Port: 8000
- Access Key: local
- Secret Key: local
- Region: us-east-1

### Connection Information

```
Endpoint: http://localhost:8000
Access Key: local
Secret Key: local
Region: us-east-1
```

### Initialization Script

The database is automatically initialized with the `init-local-db.sh` script, which:

1. Creates the Weather table with the required schema
2. Populates the table with sample weather data for various airports (JFK, LAX, ORD, MIA, SFO)

## Integration with Main Application

This database is designed to work seamlessly with the main Airline Backend Java application. When used with the main application's docker-compose.yml, it will be started automatically as a service.

## Ephemeral Nature

The database runs with the `-inMemory` flag, which means:

1. All data is stored in memory
2. Data is automatically cleared when the container is stopped
3. Each restart provides a clean, initialized database state

This is ideal for development and testing environments where consistent, isolated testing is required.

## AWS CLI Access

You can interact with the DynamoDB Local instance using the AWS CLI:

```bash
# List tables
aws dynamodb list-tables --endpoint-url http://localhost:8000

# Query weather data for JFK
aws dynamodb query \
    --endpoint-url http://localhost:8000 \
    --table-name Weather \
    --key-condition-expression "location_id = :loc" \
    --expression-attribute-values '{":loc":{"S":"JFK"}}'
```
