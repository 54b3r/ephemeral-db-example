#!/bin/bash

# Configure AWS CLI for local development
aws configure set aws_access_key_id local
aws configure set aws_secret_access_key local
aws configure set region us-east-1
aws configure set output json

# Function to check if DynamoDB is ready
check_dynamodb() {
    # When running inside the container, use localhost instead of the service name
    aws dynamodb list-tables --endpoint-url http://localhost:8000 > /dev/null 2>&1
    return $?
}

# Wait for DynamoDB to be ready
echo "Waiting for DynamoDB Local to be ready..."
until check_dynamodb; do
    sleep 2
done
echo "DynamoDB Local is ready!"

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
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

# Wait for table to be active
echo "Waiting for Weather table to be active..."
aws dynamodb wait table-exists \
    --endpoint-url http://localhost:8000 \
    --table-name Weather

# Insert sample weather data for each airport
echo "Inserting sample weather data..."
for airport in "JFK" "LAX" "ORD" "MIA" "SFO"; do
    # Generate coordinates based on airport
    case $airport in
        "JFK")
            coordinates="40.6413° N, 73.7781° W"
            ;;
        "LAX")
            coordinates="33.9416° N, 118.4085° W"
            ;;
        "ORD")
            coordinates="41.9742° N, 87.9073° W"
            ;;
        "MIA")
            coordinates="25.7932° N, 80.2906° W"
            ;;
        "SFO")
            coordinates="37.6213° N, 122.3790° W"
            ;;
    esac
    
    aws dynamodb put-item \
        --endpoint-url http://localhost:8000 \
        --table-name Weather \
        --item "{
            \"location_id\": {\"S\": \"$airport\"},
            \"timestamp\": {\"N\": \"$(date +%s)\"},
            \"temperature\": {\"N\": \"$((60 + RANDOM % 30))\"},
            \"humidity\": {\"N\": \"$((50 + RANDOM % 40))\"},
            \"conditions\": {\"S\": \"Partly Cloudy\"},
            \"windSpeed\": {\"N\": \"$((5 + RANDOM % 20))\"},
            \"coordinates\": {\"S\": \"$coordinates\"}
        }"
done

echo "DynamoDB initialization complete!"
