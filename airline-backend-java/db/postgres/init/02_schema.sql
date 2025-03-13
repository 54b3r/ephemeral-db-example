-- Create tables matching the JPA entity models

-- Aircraft table
CREATE TABLE IF NOT EXISTS aircrafts (
    aircraft_code CHAR(3) PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    range INTEGER NOT NULL CHECK (range > 0),
    seats_total INTEGER CHECK (seats_total > 0)
);

-- Airport table
CREATE TABLE IF NOT EXISTS airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    coordinates POINT NOT NULL,
    timezone VARCHAR(50) NOT NULL
);

-- Flight table with proper references
CREATE TABLE IF NOT EXISTS flights (
    flight_id SERIAL PRIMARY KEY,
    flight_no CHAR(6) NOT NULL,
    scheduled_departure TIMESTAMP NOT NULL,
    scheduled_arrival TIMESTAMP NOT NULL,
    departure_airport CHAR(3) NOT NULL REFERENCES airports(airport_code),
    arrival_airport CHAR(3) NOT NULL REFERENCES airports(airport_code),
    status VARCHAR(20) NOT NULL CHECK (status IN ('Scheduled', 'Delayed', 'Departed', 'Arrived', 'Cancelled')),
    aircraft_code CHAR(3) NOT NULL REFERENCES aircrafts(aircraft_code),
    actual_departure TIMESTAMP NULL,
    actual_arrival TIMESTAMP NULL,
    CHECK (scheduled_arrival > scheduled_departure),
    CHECK (actual_arrival IS NULL OR actual_departure IS NOT NULL),
    CHECK (actual_arrival IS NULL OR actual_arrival > actual_departure)
);

-- Booking table
CREATE TABLE IF NOT EXISTS bookings (
    booking_ref CHAR(6) PRIMARY KEY,
    book_date TIMESTAMP NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0)
);

-- Ticket table with proper references
CREATE TABLE IF NOT EXISTS tickets (
    ticket_no CHAR(13) PRIMARY KEY,
    booking_ref CHAR(6) NOT NULL REFERENCES bookings(booking_ref),
    passenger_id VARCHAR(20) NOT NULL,
    passenger_name TEXT NOT NULL,
    contact_data JSONB
);

-- Ticket flights join table with proper references
CREATE TABLE IF NOT EXISTS ticket_flights (
    ticket_no CHAR(13) NOT NULL REFERENCES tickets(ticket_no),
    flight_id INTEGER NOT NULL REFERENCES flights(flight_id),
    fare_conditions VARCHAR(10) NOT NULL CHECK (fare_conditions IN ('Economy', 'Business', 'First')),
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    PRIMARY KEY (ticket_no, flight_id)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS flights_departure_airport_idx ON flights(departure_airport);
CREATE INDEX IF NOT EXISTS flights_arrival_airport_idx ON flights(arrival_airport);
CREATE INDEX IF NOT EXISTS flights_aircraft_code_idx ON flights(aircraft_code);
CREATE INDEX IF NOT EXISTS flights_status_idx ON flights(status);
CREATE INDEX IF NOT EXISTS flights_scheduled_departure_idx ON flights(scheduled_departure);
CREATE INDEX IF NOT EXISTS tickets_booking_ref_idx ON tickets(booking_ref);
