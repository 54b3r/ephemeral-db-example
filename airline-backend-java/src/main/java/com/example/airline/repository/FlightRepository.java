package com.example.airline.repository;

import com.example.airline.model.Flight;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.time.LocalDateTime;
import java.util.List;

public interface FlightRepository extends JpaRepository<Flight, Integer> {
    List<Flight> findByDepartureAirport_AirportCode(String departureAirport);
    List<Flight> findByArrivalAirport_AirportCode(String arrivalAirport);
    
    @Query("SELECT f FROM Flight f WHERE f.scheduledDeparture >= ?1 AND f.scheduledDeparture <= ?2")
    List<Flight> findFlightsInDateRange(LocalDateTime start, LocalDateTime end);
    
    List<Flight> findByStatus(String status);
}
