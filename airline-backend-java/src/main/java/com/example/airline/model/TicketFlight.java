package com.example.airline.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "ticket_flights")
public class TicketFlight {
    @EmbeddedId
    private TicketFlightId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("ticketNo")
    @JoinColumn(name = "ticket_no", columnDefinition = "bpchar(13)")
    private Ticket ticket;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("flightId")
    @JoinColumn(name = "flight_id", columnDefinition = "integer")
    private Flight flight;

    @Column(name = "fare_conditions", columnDefinition = "varchar(10)", nullable = false)
    private String fareConditions;

    @Column(name = "amount", columnDefinition = "numeric(10,2)", nullable = false)
    private Double amount;
}
