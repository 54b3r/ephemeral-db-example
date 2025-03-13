package com.example.airline.service;

import com.example.airline.model.Flight;
import com.example.airline.repository.FlightRepository;
import com.example.airline.repository.AirportRepository;
import com.example.airline.repository.AircraftRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class FlightService {
    private final FlightRepository flightRepository;
    private final AirportRepository airportRepository;
    private final AircraftRepository aircraftRepository;

    public List<Flight> getAllFlights() {
        return flightRepository.findAll();
    }

    public Optional<Flight> getFlightById(Integer id) {
        return flightRepository.findById(id);
    }

    public List<Flight> getFlightsByDepartureAirport(String airportCode) {
        return flightRepository.findByDepartureAirport_AirportCode(airportCode);
    }

    public List<Flight> getFlightsByArrivalAirport(String airportCode) {
        return flightRepository.findByArrivalAirport_AirportCode(airportCode);
    }

    public List<Flight> getFlightsByDateRange(LocalDateTime start, LocalDateTime end) {
        return flightRepository.findFlightsInDateRange(start, end);
    }

    public List<Flight> getFlightsByStatus(String status) {
        return flightRepository.findByStatus(status);
    }

    @Transactional
    public Flight saveFlight(Flight flight) {
        // Validate references exist
        airportRepository.findById(flight.getDepartureAirport().getAirportCode())
            .orElseThrow(() -> new IllegalArgumentException("Departure airport not found"));
        
        airportRepository.findById(flight.getArrivalAirport().getAirportCode())
            .orElseThrow(() -> new IllegalArgumentException("Arrival airport not found"));
        
        aircraftRepository.findById(flight.getAircraft().getAircraftCode())
            .orElseThrow(() -> new IllegalArgumentException("Aircraft not found"));
        
        return flightRepository.save(flight);
    }

    @Transactional
    public void deleteFlight(Integer id) {
        flightRepository.deleteById(id);
    }

    @Transactional
    public Flight updateFlightStatus(Integer id, String status) {
        Flight flight = flightRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Flight not found"));
        flight.setStatus(status);
        return flightRepository.save(flight);
    }
}
