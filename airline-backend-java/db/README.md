# Database Configuration

This directory contains all database-related configuration and initialization scripts, separated by database type.

## Directory Structure

```
db/
├── postgres/              # PostgreSQL configuration
│   └── init/             # Initialization scripts (run in alphabetical order)
│       ├── 01_extensions.sql    # Required PostgreSQL extensions
│       ├── 02_schema.sql       # Table definitions and constraints
│       └── 03_sample_data.sql  # Sample data for testing
└── README.md             # This file
```

## PostgreSQL Setup

The PostgreSQL database is configured to be completely ephemeral, meaning:
- Uses `tmpfs` for storage (data is stored in memory)
- Data is reset on container restart
- Schema and sample data are automatically loaded on startup
- No persistent volumes are used

### Schema Overview

The database schema follows the PGAir model with the following tables:
1. `aircrafts` - Aircraft fleet information
2. `airports` - Airport details with coordinates
3. `flights` - Flight schedules and status
4. `bookings` - Booking records
5. `tickets` - Passenger tickets
6. `ticket_flights` - Flight-specific ticket details

### Sample Data

The sample data provides a minimal but complete dataset for testing:
- 5 aircraft of different models
- 5 major US airports
- Sample flights between these airports
- Example booking with ticket

## DynamoDB Local Setup

DynamoDB Local is used for weather data storage:
- Runs in ephemeral mode (`-inMemory` flag)
- Shared database mode enabled (`-sharedDb` flag)
- Weather table is created on startup
- Sample weather data is loaded automatically

## Development

### Starting the Databases
```bash
docker-compose up -d
```

### Resetting the Data
Simply restart the containers:
```bash
docker-compose restart
```

### Complete Reset
To completely reset both databases:
```bash
docker-compose down
docker-compose up -d
```
