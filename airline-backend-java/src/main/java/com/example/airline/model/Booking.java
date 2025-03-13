package com.example.airline.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "bookings")
public class Booking {
    @Id
    @Column(name = "booking_ref", columnDefinition = "bpchar(6)")
    private String bookRef;

    @Column(name = "book_date", columnDefinition = "timestamp", nullable = false)
    private LocalDateTime bookDate;

    @Column(name = "total_amount", columnDefinition = "numeric(10,2)", nullable = false)
    private Double totalAmount;
}
