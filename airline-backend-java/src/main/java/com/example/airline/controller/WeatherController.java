package com.example.airline.controller;

import com.example.airline.model.Weather;
import com.example.airline.service.WeatherService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.List;

@RestController
@RequestMapping("/api/v1/weather")
public class WeatherController {
    private final WeatherService weatherService;

    public WeatherController(WeatherService weatherService) {
        this.weatherService = weatherService;
    }

    @GetMapping("/{locationId}/current")
    public ResponseEntity<List<Weather>> getRecentWeather(@PathVariable String locationId) {
        return ResponseEntity.ok(weatherService.getRecentWeather(locationId));
    }

    @GetMapping("/{locationId}")
    public ResponseEntity<List<Weather>> getWeatherForDateRange(
            @PathVariable String locationId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startTime,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endTime) {
        
        long startTimestamp = startTime.toInstant(ZoneOffset.UTC).getEpochSecond();
        long endTimestamp = endTime.toInstant(ZoneOffset.UTC).getEpochSecond();
        
        return ResponseEntity.ok(
            weatherService.getWeatherForLocation(locationId, startTimestamp, endTimestamp)
        );
    }

    @GetMapping("/{locationId}/{timestamp}")
    public ResponseEntity<Weather> getWeather(
            @PathVariable String locationId,
            @PathVariable Long timestamp) {
        Weather weather = weatherService.getWeather(locationId, timestamp);
        return weather != null ? ResponseEntity.ok(weather) : ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<Void> saveWeather(@RequestBody Weather weather) {
        if (weather.getTimestamp() == null) {
            weather.setTimestamp(Instant.now().getEpochSecond());
        }
        weatherService.saveWeather(weather);
        return ResponseEntity.ok().build();
    }
}
