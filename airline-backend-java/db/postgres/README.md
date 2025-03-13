# Ephemeral PostgreSQL Database

This directory contains a portable, ephemeral PostgreSQL database configuration for development and testing purposes.

## Features

- **Ephemeral Storage**: Uses `tmpfs` to store all data in memory, ensuring a clean state on each restart
- **PostGIS Extension**: Built on the PostGIS image for geospatial capabilities
- **Automatic Initialization**: Includes initialization scripts for schema creation and sample data
- **Portable Configuration**: Can be used independently or as part of the main application

## Usage

### Standalone Mode

To run the PostgreSQL database independently:

```bash
cd db/postgres
docker-compose up -d
```

This will start a PostgreSQL database with the following configuration:
- Port: 5432
- Username: postgres
- Password: postgres
- Database: pgair

### Connection Information

```
Host: localhost
Port: 5432
Database: pgair
Username: postgres
Password: postgres
```

### Initialization Scripts

The database is automatically initialized with the following scripts:

1. `01_extensions.sql`: Enables required PostgreSQL extensions
2. `02_schema.sql`: Creates the database schema and loads sample data

## Integration with Main Application

This database is designed to work seamlessly with the main Airline Backend Java application. When used with the main application's docker-compose.yml, it will be started automatically as a service.

## Ephemeral Nature

The database uses a `tmpfs` mount for `/var/lib/postgresql/data`, which means:

1. All data is stored in memory
2. Data is automatically cleared when the container is stopped
3. Each restart provides a clean, initialized database state

This is ideal for development and testing environments where consistent, isolated testing is required.
