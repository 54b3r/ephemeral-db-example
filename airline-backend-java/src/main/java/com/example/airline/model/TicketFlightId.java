package com.example.airline.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.Data;
import java.io.Serializable;

@Data
@Embeddable
public class TicketFlightId implements Serializable {
    @Column(name = "ticket_no", columnDefinition = "bpchar(13)")
    private String ticketNo;

    @Column(name = "flight_id", columnDefinition = "integer")
    private Integer flightId;
}
