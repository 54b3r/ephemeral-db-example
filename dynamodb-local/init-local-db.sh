#!/bin/bash

# Create Movies table
echo "Creating Movies table..."
aws dynamodb create-table \
    --endpoint-url http://localhost:8000 \
    --table-name Movies \
    --attribute-definitions \
        AttributeName=year,AttributeType=N \
        AttributeName=title,AttributeType=S \
    --key-schema \
        AttributeName=year,KeyType=HASH \
        AttributeName=title,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=10,WriteCapacityUnits=10

# Add sample movie data
echo "Adding sample movie data..."
aws dynamodb put-item \
    --endpoint-url http://localhost:8000 \
    --table-name Movies \
    --item '{
        "year": {"N": "2013"},
        "title": {"S": "Rush"},
        "info": {"M": {
            "directors": {"L": [{"S": "Ron Howard"}]},
            "rating": {"N": "8.3"}
        }}
    }'

# Create Weather table
echo "Creating Weather table..."
aws dynamodb create-table \
    --endpoint-url http://localhost:8000 \
    --table-name Weather \
    --attribute-definitions \
        AttributeName=location_id,AttributeType=S \
        AttributeName=timestamp,AttributeType=N \
    --key-schema \
        AttributeName=location_id,KeyType=HASH \
        AttributeName=timestamp,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=10,WriteCapacityUnits=10

# Add sample weather data
echo "Adding sample weather data..."
aws dynamodb put-item \
    --endpoint-url http://localhost:8000 \
    --table-name Weather \
    --item '{
        "location_id": {"S": "new_york"},
        "timestamp": {"N": "1709424000"},
        "temperature": {"N": "20.5"},
        "humidity": {"N": "65"},
        "precipitation": {"N": "0"},
        "wind_speed": {"N": "15.5"},
        "city": {"S": "New York"},
        "coordinates": {"S": "40.7128,-74.0060"}
    }'

echo "Database initialization complete!"
