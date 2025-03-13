package com.example.airline.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class FlightDTO {
    private Integer flightId;
    private String flightNo;
    private LocalDateTime scheduledDeparture;
    private LocalDateTime scheduledArrival;
    private String departureAirportCode;
    private String arrivalAirportCode;
    private String status;
    private String aircraftCode;
    private LocalDateTime actualDeparture;
    private LocalDateTime actualArrival;
    
    // Additional fields for nested information
    private String departureAirportName;
    private String arrivalAirportName;
    private String aircraftModel;
}
