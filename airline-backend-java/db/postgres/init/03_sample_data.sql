-- Sample data for testing the airline backend application

-- Aircraft data with realistic models and ranges
INSERT INTO aircrafts (aircraft_code, model, range, seats_total) VALUES
    ('773', 'Boeing 777-300', 11100, 402),
    ('763', 'Boeing 767-300', 7900, 222),
    ('320', 'Airbus A320-200', 5700, 140),
    ('321', 'Airbus A321-200', 5600, 170),
    ('319', 'Airbus A319-100', 6700, 116);

-- Major US airports with accurate coordinates and timezones
INSERT INTO airports (airport_code, airport_name, city, coordinates, timezone) VALUES
    ('JFK', 'John F Kennedy International Airport', 'New York', POINT(-73.778889, 40.639722), 'America/New_York'),
    ('LAX', 'Los Angeles International Airport', 'Los Angeles', POINT(-118.408056, 33.942536), 'America/Los_Angeles'),
    ('ORD', 'O''Hare International Airport', 'Chicago', POINT(-87.904722, 41.978611), 'America/Chicago'),
    ('MIA', 'Miami International Airport', 'Miami', POINT(-80.290556, 25.793333), 'America/New_York'),
    ('SFO', 'San Francisco International Airport', 'San Francisco', POINT(-122.375, 37.618889), 'America/Los_Angeles');

-- Sample flights with different statuses for testing status-based queries
INSERT INTO flights 
    (flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, status, aircraft_code, actual_departure, actual_arrival)
VALUES
    -- Completed flight
    ('AA1001', NOW() - interval '5 hours', NOW() - interval '2 hours', 'JFK', 'LAX', 'Arrived', '773',
     NOW() - interval '5 hours', NOW() - interval '2 hours'),
    
    -- Currently in air
    ('AA1002', NOW() - interval '2 hours', NOW() + interval '1 hour', 'LAX', 'SFO', 'Departed', '320',
     NOW() - interval '2 hours', NULL),
    
    -- Delayed flight
    ('AA1003', NOW() - interval '1 hour', NOW() + interval '2 hours', 'ORD', 'MIA', 'Delayed', '321',
     NULL, NULL),
    
    -- Upcoming flights (for testing date range queries)
    ('AA1004', NOW() + interval '2 hours', NOW() + interval '5 hours', 'JFK', 'LAX', 'Scheduled', '773',
     NULL, NULL),
    ('AA1005', NOW() + interval '3 hours', NOW() + interval '5 hours', 'LAX', 'SFO', 'Scheduled', '320',
     NULL, NULL),
    ('AA1006', NOW() + interval '4 hours', NOW() + interval '7 hours', 'ORD', 'MIA', 'Scheduled', '321',
     NULL, NULL),
    
    -- Cancelled flight
    ('AA1007', NOW() + interval '6 hours', NOW() + interval '9 hours', 'SFO', 'JFK', 'Cancelled', '773',
     NULL, NULL);

-- Sample bookings with different fare conditions
INSERT INTO bookings (booking_ref, book_date, total_amount) VALUES
    ('ABC123', NOW() - interval '1 day', 550.00),
    ('DEF456', NOW() - interval '2 days', 1200.00),
    ('GHI789', NOW() - interval '3 days', 850.00);

-- Sample tickets with passenger information
INSERT INTO tickets (ticket_no, booking_ref, passenger_id, passenger_name, contact_data) VALUES
    ('1234567890123', 'ABC123', 'PS123456', 'John Doe', 
     '{"phone": "+1-234-567-8901", "email": "john.doe@example.com"}'),
    ('2345678901234', 'DEF456', 'PS234567', 'Jane Smith',
     '{"phone": "+1-345-678-9012", "email": "jane.smith@example.com"}'),
    ('3456789012345', 'GHI789', 'PS345678', 'Bob Wilson',
     '{"phone": "+1-456-789-0123", "email": "bob.wilson@example.com"}');

-- Sample ticket_flights with different fare conditions
INSERT INTO ticket_flights (ticket_no, flight_id, fare_conditions, amount) VALUES
    ('1234567890123', 1, 'Economy', 550.00),
    ('2345678901234', 2, 'Business', 1200.00),
    ('3456789012345', 3, 'Economy', 850.00);
