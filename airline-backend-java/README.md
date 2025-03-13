# Airline Backend Java

A Spring Boot application that interacts with PGAir database for testing and DevEx purposes. This backend provides a comprehensive REST API for managing airline operations including flights, aircraft, and airports.

## Prerequisites

- Java 17 or higher
- Maven
- Docker and Docker Compose

## Quick Start

1. Install Maven (if not installed):
   ```bash
   brew install maven
   ```

2. Clone the repository and navigate to the project directory:
   ```bash
   cd airline-backend-java
   ```

3. Build the project:
   ```bash
   mvn clean install
   ```

4. Start the application and database:
   ```bash
   docker-compose up -d
   ```

The application will be available at http://localhost:8080

## Project Structure

```
airline-backend-java/
├── src/
│   ├── main/
│   │   ├── java/com/example/airline/
│   │   │   ├── AirlineApplication.java  # Main application class
│   │   │   ├── controller/             # REST API controllers
│   │   │   ├── service/                # Business logic layer
│   │   │   ├── repository/             # Data access layer
│   │   │   ├── model/                  # Entity classes
│   │   │   ├── dto/                    # Data Transfer Objects
│   │   │   └── exception/              # Error handling
│   │   └── resources/
│   │       └── application.properties  # Application configuration
│   └── test/
│       ├── java/com/example/airline/
│       │   ├── controller/             # Controller tests
│       │   ├── service/                # Service tests
│       │   └── repository/             # Repository tests
│       └── resources/
│           └── application-test.properties  # Test configuration
├── pom.xml                    # Maven project configuration
├── docker-compose.yml         # Docker services configuration
└── Dockerfile                # Application container configuration
```

## API Documentation

### Aircraft API (Base URL: /api/v1/aircraft)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | /        | List all aircraft |
| GET    | /{code}  | Get aircraft by code |
| POST   | /        | Create new aircraft |
| PUT    | /{code}  | Update aircraft |
| DELETE | /{code}  | Delete aircraft |

Example request for creating an aircraft:
```bash
curl -X POST http://localhost:8080/api/v1/aircraft \
  -H 'Content-Type: application/json' \
  -d '{
    "aircraftCode": "773",
    "model": "Boeing 777-300",
    "range": 11100,
    "seatsTotal": 402
  }'
```

### Flight API (Base URL: /api/v1/flights)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | /        | List all flights |
| GET    | /{id}    | Get flight by ID |
| GET    | /departure/{airportCode} | Get flights by departure airport |
| GET    | /arrival/{airportCode}   | Get flights by arrival airport |
| GET    | /search?start=&end=      | Search flights by date range |
| GET    | /status/{status}         | Get flights by status |
| POST   | /        | Create new flight |
| PUT    | /{id}    | Update flight |
| PATCH  | /{id}/status | Update flight status |
| DELETE | /{id}    | Delete flight |

Example search request:
```bash
curl 'http://localhost:8080/api/v1/flights/search?\
start=2025-03-12T00:00:00&end=2025-03-13T00:00:00'
```

## Databases

### PostgreSQL (PGAir)

The application uses PGAir database (ghcr.io/stormasm/pgair) which provides a comprehensive airline database schema including:
- Airports and aircraft data
- Flight schedules and statuses
- Booking and ticket management

The database is automatically set up by Docker Compose with the following credentials:
- Host: localhost
- Port: 5432
- Database: pgair
- Username: postgres
- Password: postgres

### DynamoDB Local

The application also integrates with DynamoDB Local for weather data storage and retrieval. It runs in ephemeral mode (data is reset on container restart) and uses shared database mode.

Configuration:
- Host: localhost
- Port: 8000
- Access Key: local
- Secret Key: local
- Region: us-east-1

#### Weather API (Base URL: /api/v1/weather)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | /{locationId}/current | Get recent weather (last 24h) for a location |
| GET    | /{locationId} | Get weather by date range |
| GET    | /{locationId}/{timestamp} | Get weather by exact timestamp |
| POST   | / | Save new weather data |

Example requests:
```bash
# Get recent weather for JFK airport
curl http://localhost:8080/api/v1/weather/JFK/current

# Get weather for a specific time range
curl 'http://localhost:8080/api/v1/weather/LAX?\
startTime=2025-03-12T00:00:00&endTime=2025-03-12T23:59:59'

# Save new weather data
curl -X POST http://localhost:8080/api/v1/weather \
  -H 'Content-Type: application/json' \
  -d '{
    "locationId": "SFO",
    "temperature": 22.5,
    "humidity": 65.0,
    "conditions": "Sunny",
    "windSpeed": 10.2,
    "coordinates": "37.6213° N, 122.3790° W"
  }'

## Ephemeral Database POC

This project serves as a Proof of Concept (POC) for using ephemeral databases in a development and testing environment. The key features include:

### Ephemeral Databases

1. **PostgreSQL (PGAir)**
   - Uses `tmpfs` for `/var/lib/postgresql/data` to store data in memory
   - All data is reset when the container is restarted
   - Provides a clean testing environment for each session

2. **DynamoDB Local**
   - Runs with the `-inMemory` flag to store all data in memory
   - Data is reset when the container is restarted
   - Simulates AWS DynamoDB for local development

### Application Data Persistence

While the databases are ephemeral, the application's temporary files are stored in a persistent Docker volume:

```yaml
volumes:
  # Volume for application temp files to prevent disk space issues
  app_temp:
    driver: local
```

This configuration prevents "No space left on device" errors while maintaining the ephemeral nature of the databases.

## Tested Endpoints

The following endpoints have been tested and verified to work correctly:

### PostgreSQL Integration

1. **Aircraft Endpoint**
   ```bash
   curl -s http://localhost:8080/api/v1/aircraft | jq
   ```
   - Successfully returns a list of aircraft from the PostgreSQL database
   - Confirms JPA integration is working correctly

2. **Flights Endpoint**
   ```bash
   curl -s http://localhost:8080/api/v1/flights | jq
   ```
   - Successfully returns a list of flights with related data
   - Confirms complex JPA relationships are working correctly

### DynamoDB Integration

1. **Weather Endpoint**
   ```bash
   curl -s http://localhost:8080/api/v1/weather/JFK/current | jq
   ```
   - Successfully returns weather data for JFK airport from DynamoDB
   - Confirms AWS SDK integration is working correctly

   ```bash
   curl -s http://localhost:8080/api/v1/weather/LAX/current | jq
   ```
   - Successfully returns weather data for LAX airport from DynamoDB

## Testing Script

A testing script is provided to easily verify the functionality of the application. Run it with:

```bash
./test-endpoints.sh
```

This script will test all the major endpoints and provide a summary of the results.

## Development

### Running Tests
```bash
mvn test
```

### Accessing Logs
View application logs:
```bash
docker-compose logs -f app
```

View database logs:
```bash
docker-compose logs -f pgair-db
```

### Stopping the Application
```bash
docker-compose down
```

To remove all data volumes and restart with a clean environment:
```bash
docker-compose down -v && docker-compose up -d
```

## Error Handling

The API uses standard HTTP status codes:
- 200: Success
- 201: Created
- 400: Bad Request
- 404: Not Found
- 500: Internal Server Error

Error responses include:
```json
{
  "timestamp": "2025-03-12T10:42:35",
  "message": "Error description",
  "type": "ErrorType"
}
```
