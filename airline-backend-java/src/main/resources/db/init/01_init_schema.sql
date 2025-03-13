-- Enable PostGIS extension for coordinates
CREATE EXTENSION IF NOT EXISTS postgis;

-- Create tables
CREATE TABLE IF NOT EXISTS aircrafts (
    aircraft_code CHAR(3) PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    range INTEGER NOT NULL,
    seats_total INTEGER
);

CREATE TABLE IF NOT EXISTS airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    coordinates POINT NOT NULL,
    timezone VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS flights (
    flight_id SERIAL PRIMARY KEY,
    flight_no CHAR(6) NOT NULL,
    scheduled_departure TIMESTAMP NOT NULL,
    scheduled_arrival TIMESTAMP NOT NULL,
    departure_airport CHAR(3) REFERENCES airports(airport_code),
    arrival_airport CHAR(3) REFERENCES airports(airport_code),
    status VARCHAR(20) NOT NULL,
    aircraft_code CHAR(3) REFERENCES aircrafts(aircraft_code),
    actual_departure TIMESTAMP,
    actual_arrival TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bookings (
    booking_ref CHAR(6) PRIMARY KEY,
    book_date TIMESTAMP NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS tickets (
    ticket_no CHAR(13) PRIMARY KEY,
    booking_ref CHAR(6) REFERENCES bookings(booking_ref),
    passenger_id VARCHAR(20) NOT NULL,
    passenger_name VARCHAR(100) NOT NULL,
    contact_data JSONB
);

CREATE TABLE IF NOT EXISTS ticket_flights (
    ticket_no CHAR(13) REFERENCES tickets(ticket_no),
    flight_id INTEGER REFERENCES flights(flight_id),
    fare_conditions VARCHAR(10) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ticket_no, flight_id)
);

-- Insert sample data
INSERT INTO aircrafts (aircraft_code, model, range, seats_total) VALUES
    ('773', 'Boeing 777-300', 11100, 402),
    ('763', 'Boeing 767-300', 7900, 222),
    ('320', 'Airbus A320-200', 5700, 140),
    ('321', 'Airbus A321-200', 5600, 170),
    ('319', 'Airbus A319-100', 6700, 116);

INSERT INTO airports (airport_code, airport_name, city, coordinates, timezone) VALUES
    ('JFK', 'John F Kennedy International Airport', 'New York', POINT(-73.778889, 40.639722), 'America/New_York'),
    ('LAX', 'Los Angeles International Airport', 'Los Angeles', POINT(-118.408056, 33.942536), 'America/Los_Angeles'),
    ('ORD', 'O''Hare International Airport', 'Chicago', POINT(-87.904722, 41.978611), 'America/Chicago'),
    ('MIA', 'Miami International Airport', 'Miami', POINT(-80.290556, 25.793333), 'America/New_York'),
    ('SFO', 'San Francisco International Airport', 'San Francisco', POINT(-122.375, 37.618889), 'America/Los_Angeles');

-- Insert sample flights (next 24 hours)
INSERT INTO flights (flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, status, aircraft_code) VALUES
    ('AA1234', NOW() + interval '2 hours', NOW() + interval '5 hours', 'JFK', 'LAX', 'Scheduled', '773'),
    ('AA5678', NOW() + interval '3 hours', NOW() + interval '5 hours', 'LAX', 'SFO', 'Scheduled', '320'),
    ('AA9012', NOW() + interval '4 hours', NOW() + interval '7 hours', 'ORD', 'MIA', 'Scheduled', '321');

-- Insert sample booking
INSERT INTO bookings (booking_ref, book_date, total_amount) VALUES
    ('ABC123', NOW(), 550.00);

-- Insert sample ticket
INSERT INTO tickets (ticket_no, booking_ref, passenger_id, passenger_name, contact_data) VALUES
    ('1234567890123', 'ABC123', 'PS123456', 'John Doe', '{"phone": "+1-234-567-8901", "email": "john.doe@example.com"}');

-- Insert sample ticket_flight
INSERT INTO ticket_flights (ticket_no, flight_id, fare_conditions, amount) VALUES
    ('1234567890123', 1, 'Economy', 550.00);
