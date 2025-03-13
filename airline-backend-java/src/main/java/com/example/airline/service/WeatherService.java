package com.example.airline.service;

import com.example.airline.model.Weather;
import com.example.airline.repository.WeatherRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WeatherService {
    private final WeatherRepository weatherRepository;

    public WeatherService(WeatherRepository weatherRepository) {
        this.weatherRepository = weatherRepository;
    }

    public Weather getWeather(String locationId, Long timestamp) {
        return weatherRepository.getWeather(locationId, timestamp);
    }

    public List<Weather> getRecentWeather(String locationId) {
        return weatherRepository.getRecentWeather(locationId);
    }

    public List<Weather> getWeatherForLocation(String locationId, long startTime, long endTime) {
        return weatherRepository.getWeatherForLocation(locationId, startTime, endTime);
    }

    public void saveWeather(Weather weather) {
        weatherRepository.saveWeather(weather);
    }
}
