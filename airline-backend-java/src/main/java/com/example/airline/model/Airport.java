package com.example.airline.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "airports")
public class Airport {
    @Id
    @Column(name = "airport_code", columnDefinition = "bpchar(3)")
    private String airportCode;

    @Column(name = "airport_name", columnDefinition = "varchar(100)", nullable = false)
    private String airportName;

    @Column(name = "city", columnDefinition = "varchar(50)", nullable = false)
    private String city;

    @Column(name = "coordinates", columnDefinition = "point", nullable = false)
    private String coordinates;

    @Column(name = "timezone", columnDefinition = "varchar(50)", nullable = false)
    private String timezone;
}
