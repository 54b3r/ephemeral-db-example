package com.example.airline.controller;

import com.example.airline.dto.FlightDTO;
import com.example.airline.model.Flight;
import com.example.airline.model.Aircraft;
import com.example.airline.model.Airport;
import com.example.airline.service.FlightService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/flights")
@RequiredArgsConstructor
public class FlightController {
    private final FlightService flightService;

    @GetMapping
    public ResponseEntity<List<FlightDTO>> getAllFlights() {
        List<FlightDTO> flights = flightService.getAllFlights()
            .stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        return ResponseEntity.ok(flights);
    }

    @GetMapping("/{id}")
    public ResponseEntity<FlightDTO> getFlightById(@PathVariable Integer id) {
        return flightService.getFlightById(id)
            .map(flight -> ResponseEntity.ok(convertToDTO(flight)))
            .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/departure/{airportCode}")
    public ResponseEntity<List<FlightDTO>> getFlightsByDepartureAirport(@PathVariable String airportCode) {
        List<FlightDTO> flights = flightService.getFlightsByDepartureAirport(airportCode)
            .stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        return ResponseEntity.ok(flights);
    }

    @GetMapping("/arrival/{airportCode}")
    public ResponseEntity<List<FlightDTO>> getFlightsByArrivalAirport(@PathVariable String airportCode) {
        List<FlightDTO> flights = flightService.getFlightsByArrivalAirport(airportCode)
            .stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        return ResponseEntity.ok(flights);
    }

    @GetMapping("/search")
    public ResponseEntity<List<FlightDTO>> searchFlights(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        List<FlightDTO> flights = flightService.getFlightsByDateRange(start, end)
            .stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        return ResponseEntity.ok(flights);
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<FlightDTO>> getFlightsByStatus(@PathVariable String status) {
        List<FlightDTO> flights = flightService.getFlightsByStatus(status)
            .stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        return ResponseEntity.ok(flights);
    }

    @PostMapping
    public ResponseEntity<?> createFlight(@RequestBody FlightDTO flightDTO) {
        try {
            Flight flight = convertToEntity(flightDTO);
            Flight savedFlight = flightService.saveFlight(flight);
            return ResponseEntity.ok(convertToDTO(savedFlight));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateFlight(@PathVariable Integer id, @RequestBody FlightDTO flightDTO) {
        if (!id.equals(flightDTO.getFlightId())) {
            return ResponseEntity.badRequest().body("Flight ID mismatch");
        }
        
        try {
            Flight flight = convertToEntity(flightDTO);
            Flight updatedFlight = flightService.saveFlight(flight);
            return ResponseEntity.ok(convertToDTO(updatedFlight));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<?> updateFlightStatus(
            @PathVariable Integer id,
            @RequestParam String status) {
        try {
            Flight updatedFlight = flightService.updateFlightStatus(id, status);
            return ResponseEntity.ok(convertToDTO(updatedFlight));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteFlight(@PathVariable Integer id) {
        flightService.deleteFlight(id);
        return ResponseEntity.noContent().build();
    }

    private FlightDTO convertToDTO(Flight flight) {
        FlightDTO dto = new FlightDTO();
        dto.setFlightId(flight.getFlightId());
        dto.setFlightNo(flight.getFlightNo());
        dto.setScheduledDeparture(flight.getScheduledDeparture());
        dto.setScheduledArrival(flight.getScheduledArrival());
        dto.setDepartureAirportCode(flight.getDepartureAirport().getAirportCode());
        dto.setArrivalAirportCode(flight.getArrivalAirport().getAirportCode());
        dto.setStatus(flight.getStatus());
        dto.setAircraftCode(flight.getAircraft().getAircraftCode());
        dto.setActualDeparture(flight.getActualDeparture());
        dto.setActualArrival(flight.getActualArrival());
        
        // Additional information
        dto.setDepartureAirportName(flight.getDepartureAirport().getAirportName());
        dto.setArrivalAirportName(flight.getArrivalAirport().getAirportName());
        dto.setAircraftModel(flight.getAircraft().getModel());
        
        return dto;
    }

    private Flight convertToEntity(FlightDTO dto) {
        Flight flight = new Flight();
        flight.setFlightId(dto.getFlightId());
        flight.setFlightNo(dto.getFlightNo());
        flight.setScheduledDeparture(dto.getScheduledDeparture());
        flight.setScheduledArrival(dto.getScheduledArrival());
        flight.setStatus(dto.getStatus());
        flight.setActualDeparture(dto.getActualDeparture());
        flight.setActualArrival(dto.getActualArrival());

        // Set references
        Airport departureAirport = new Airport();
        departureAirport.setAirportCode(dto.getDepartureAirportCode());
        flight.setDepartureAirport(departureAirport);

        Airport arrivalAirport = new Airport();
        arrivalAirport.setAirportCode(dto.getArrivalAirportCode());
        flight.setArrivalAirport(arrivalAirport);

        Aircraft aircraft = new Aircraft();
        aircraft.setAircraftCode(dto.getAircraftCode());
        flight.setAircraft(aircraft);

        return flight;
    }
}
