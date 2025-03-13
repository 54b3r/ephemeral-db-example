package com.example.airline.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.*;

import java.net.URI;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Slf4j
@Component
public class DynamoDBInitializer {

    private final DynamoDbClient dynamoDbClient;
    private final Random random = new Random();

    public DynamoDBInitializer(@Value("${aws.dynamodb.endpoint}") String dynamoDbEndpoint) {
        this.dynamoDbClient = DynamoDbClient.builder()
                .endpointOverride(URI.create(dynamoDbEndpoint))
                .build();
    }

    @EventListener(ApplicationReadyEvent.class)
    public void initializeDynamoDB() {
        try {
            createWeatherTable();
            insertSampleData();
            log.info("DynamoDB initialization completed successfully");
        } catch (Exception e) {
            log.error("Error initializing DynamoDB: {}", e.getMessage(), e);
        }
    }

    private void createWeatherTable() {
        String tableName = "Weather";

        try {
            dynamoDbClient.describeTable(DescribeTableRequest.builder()
                    .tableName(tableName)
                    .build());
            log.info("Weather table already exists");
        } catch (ResourceNotFoundException e) {
            log.info("Creating Weather table...");
            
            CreateTableRequest request = CreateTableRequest.builder()
                    .tableName(tableName)
                    .keySchema(
                            KeySchemaElement.builder()
                                    .attributeName("location_id")
                                    .keyType(KeyType.HASH)
                                    .build(),
                            KeySchemaElement.builder()
                                    .attributeName("timestamp")
                                    .keyType(KeyType.RANGE)
                                    .build()
                    )
                    .attributeDefinitions(
                            AttributeDefinition.builder()
                                    .attributeName("location_id")
                                    .attributeType(ScalarAttributeType.S)
                                    .build(),
                            AttributeDefinition.builder()
                                    .attributeName("timestamp")
                                    .attributeType(ScalarAttributeType.N)
                                    .build()
                    )
                    .billingMode(BillingMode.PAY_PER_REQUEST)
                    .build();

            dynamoDbClient.createTable(request);
            
            // Wait for table to become active
            log.info("Waiting for Weather table to become active...");
            dynamoDbClient.waiter().waitUntilTableExists(DescribeTableRequest.builder()
                    .tableName(tableName)
                    .build());
            log.info("Weather table is now active");
        }
    }

    private void insertSampleData() {
        String[] airports = {"JFK", "LAX", "ORD", "MIA", "SFO"};
        long now = Instant.now().getEpochSecond();

        for (String airport : airports) {
            Map<String, AttributeValue> item = new HashMap<>();
            item.put("location_id", AttributeValue.builder().s(airport).build());
            item.put("timestamp", AttributeValue.builder().n(String.valueOf(now)).build());
            item.put("temperature", AttributeValue.builder().n(String.valueOf(60 + random.nextInt(30))).build());
            item.put("humidity", AttributeValue.builder().n(String.valueOf(50 + random.nextInt(40))).build());
            item.put("conditions", AttributeValue.builder().s("Partly Cloudy").build());
            item.put("windSpeed", AttributeValue.builder().n(String.valueOf(5 + random.nextInt(20))).build());
            item.put("coordinates", AttributeValue.builder().s(getAirportCoordinates(airport)).build());

            PutItemRequest request = PutItemRequest.builder()
                    .tableName("Weather")
                    .item(item)
                    .build();

            dynamoDbClient.putItem(request);
            log.info("Inserted weather data for airport: {}", airport);
        }
    }

    private String getAirportCoordinates(String airport) {
        Map<String, String> coordinates = Map.of(
            "JFK", "40.6413° N, 73.7781° W",
            "LAX", "33.9416° N, 118.4085° W",
            "ORD", "41.9742° N, 87.9073° W",
            "MIA", "25.7959° N, 80.2870° W",
            "SFO", "37.6213° N, 122.3790° W"
        );
        return coordinates.getOrDefault(airport, "0.0° N, 0.0° W");
    }
}
