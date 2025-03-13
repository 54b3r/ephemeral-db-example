package com.example.airline.model;

import lombok.Data;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbBean;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbPartitionKey;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbSortKey;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbAttribute;

@Data
@DynamoDbBean
public class Weather {
    private String locationId;
    private Long timestamp;
    private Double temperature;
    private Double humidity;
    private String conditions;
    private Double windSpeed;
    private String coordinates;

    @DynamoDbPartitionKey
    @DynamoDbAttribute("location_id")
    public String getLocationId() {
        return locationId;
    }

    @DynamoDbSortKey
    @DynamoDbAttribute("timestamp")
    public Long getTimestamp() {
        return timestamp;
    }
    
    @DynamoDbAttribute("temperature")
    public Double getTemperature() {
        return temperature;
    }
    
    @DynamoDbAttribute("humidity")
    public Double getHumidity() {
        return humidity;
    }
    
    @DynamoDbAttribute("conditions")
    public String getConditions() {
        return conditions;
    }
    
    @DynamoDbAttribute("windSpeed")
    public Double getWindSpeed() {
        return windSpeed;
    }
    
    @DynamoDbAttribute("coordinates")
    public String getCoordinates() {
        return coordinates;
    }
}
