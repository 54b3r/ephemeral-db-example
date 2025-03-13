# Minimal DynamoDB Local Setup

A lightweight DynamoDB local environment for development and testing, running in ephemeral mode.

## Prerequisites

- Docker and Docker Compose
- AWS CLI (optional, for data initialization)

## Quick Start

1. Start DynamoDB Local:
   ```bash
   docker-compose up -d
   ```
   DynamoDB will be available at http://localhost:8000

2. Initialize sample data (optional):
   ```bash
   # Configure AWS CLI for local use
   aws configure set aws_access_key_id local
   aws configure set aws_secret_access_key local
   aws configure set region us-east-1

   # Run initialization script
   ./init-local-db.sh
   ```

3. Verify setup:
   ```bash
   # List tables
   aws dynamodb list-tables --endpoint-url http://localhost:8000
   ```

## Components

1. DynamoDB Local Container
   - Official `amazon/dynamodb-local:latest` image
   - Port: 8000
   - Runs in ephemeral mode (-inMemory flag)
   - Shared DB mode enabled (-sharedDb flag)
   - Default credentials:
     - AWS Access Key: local
     - AWS Secret Key: local
     - Region: us-east-1

## Sample Tables

The initialization script creates two tables with sample data:

### Movies Table
- Partition Key: year (Number)
- Sort Key: title (String)
- Sample data: One movie entry

### Weather Table
- Partition Key: location_id (String)
- Sort Key: timestamp (Number)
- Sample data: One weather record for New York

## Example Queries

```bash
# List tables
aws dynamodb list-tables --endpoint-url http://localhost:8000

# Query Movies table
aws dynamodb query \
    --endpoint-url http://localhost:8000 \
    --table-name Movies \
    --key-condition-expression "#yr = :yyyy" \
    --expression-attribute-names '{"#yr": "year"}' \
    --expression-attribute-values '{":yyyy":{"N":"2013"}}'

## Development

### Ephemeral Storage
- DynamoDB runs in in-memory mode (-inMemory flag)
- All data is stored in memory
- Data resets automatically on container restart
- Perfect for testing and development

### Optional Tools

1. DynamoDB Admin UI
   ```bash
   npm install -g dynamodb-admin
   DYNAMO_ENDPOINT=http://localhost:8000 dynamodb-admin
   ```
   Access at http://localhost:8001

2. NoSQL Workbench
   - Download from AWS website
   - Connect to http://localhost:8000

### Cleanup
```bash
docker-compose down
```

## Next Steps

1. Connect your application using AWS SDK
2. Create additional tables as needed
3. Add more sample data
