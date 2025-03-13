package com.example.airline.dto;

import lombok.Data;

@Data
public class AircraftDTO {
    private String aircraftCode;
    private String model;
    private Integer range;
    private Integer seatsTotal;
}
