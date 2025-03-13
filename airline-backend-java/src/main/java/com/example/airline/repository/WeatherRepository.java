package com.example.airline.repository;

import com.example.airline.model.Weather;
import org.springframework.stereotype.Repository;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbEnhancedClient;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbTable;
import software.amazon.awssdk.enhanced.dynamodb.Key;
import software.amazon.awssdk.enhanced.dynamodb.TableSchema;
import software.amazon.awssdk.enhanced.dynamodb.model.QueryConditional;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

@Repository
public class WeatherRepository {
    private final DynamoDbTable<Weather> weatherTable;

    public WeatherRepository(DynamoDbEnhancedClient dynamoDbEnhancedClient) {
        this.weatherTable = dynamoDbEnhancedClient.table("Weather", TableSchema.fromBean(Weather.class));
    }

    public Weather getWeather(String locationId, Long timestamp) {
        Key key = Key.builder()
                .partitionValue(locationId)
                .sortValue(timestamp)
                .build();
        return weatherTable.getItem(key);
    }

    public List<Weather> getWeatherForLocation(String locationId, long startTime, long endTime) {
        QueryConditional queryConditional = QueryConditional
                .sortBetween(Key.builder().partitionValue(locationId).sortValue(startTime).build(),
                           Key.builder().partitionValue(locationId).sortValue(endTime).build());

        return weatherTable.query(queryConditional)
                .items()
                .stream()
                .collect(Collectors.toList());
    }

    public List<Weather> getRecentWeather(String locationId) {
        long endTime = Instant.now().getEpochSecond();
        long startTime = endTime - (24 * 60 * 60); // Last 24 hours
        return getWeatherForLocation(locationId, startTime, endTime);
    }

    public void saveWeather(Weather weather) {
        weatherTable.putItem(weather);
    }
}
