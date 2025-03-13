package com.example.airline.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "tickets")
public class Ticket {
    @Id
    @Column(name = "ticket_no", columnDefinition = "bpchar(13)")
    private String ticketNo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "booking_ref", columnDefinition = "bpchar(6)", nullable = false)
    private Booking booking;

    @Column(name = "passenger_id", columnDefinition = "varchar(20)", nullable = false)
    private String passengerId;

    @Column(name = "passenger_name", nullable = false, columnDefinition = "text")
    private String passengerName;

    @Column(name = "contact_data", columnDefinition = "jsonb")
    private String contactData;
}
