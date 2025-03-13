package com.example.airline.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "flights")
public class Flight {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "flight_id", columnDefinition = "serial")
    private Integer flightId;

    @Column(name = "flight_no", columnDefinition = "bpchar(6)", nullable = false)
    private String flightNo;

    @Column(name = "scheduled_departure", columnDefinition = "timestamp", nullable = false)
    private LocalDateTime scheduledDeparture;

    @Column(name = "scheduled_arrival", columnDefinition = "timestamp", nullable = false)
    private LocalDateTime scheduledArrival;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "departure_airport", referencedColumnName = "airport_code", nullable = false)
    private Airport departureAirport;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "arrival_airport", referencedColumnName = "airport_code", nullable = false)
    private Airport arrivalAirport;

    @Column(name = "status", columnDefinition = "varchar(20)", nullable = false)
    private String status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "aircraft_code", referencedColumnName = "aircraft_code", nullable = false)
    private Aircraft aircraft;

    @Column(name = "actual_departure", columnDefinition = "timestamp")
    private LocalDateTime actualDeparture;

    @Column(name = "actual_arrival", columnDefinition = "timestamp")
    private LocalDateTime actualArrival;
}
