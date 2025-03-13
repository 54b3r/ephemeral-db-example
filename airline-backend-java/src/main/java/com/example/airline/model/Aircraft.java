package com.example.airline.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "aircrafts")
public class Aircraft {
    @Id
    @Column(name = "aircraft_code", columnDefinition = "bpchar(3)")
    private String aircraftCode;

    @Column(name = "model", columnDefinition = "varchar(50)", nullable = false)
    private String model;

    @Column(name = "range", columnDefinition = "integer", nullable = false)
    private Integer range;

    @Column(name = "seats_total", columnDefinition = "integer")
    private Integer seatsTotal;
}
