FROM postgis/postgis:15-3.4-alpine

# Set environment variables
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=pgair

# Health check to verify the database is ready
HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
  CMD pg_isready -U postgres || exit 1

# Copy initialization scripts
COPY init/ /docker-entrypoint-initdb.d/

# Use tmpfs for data to ensure ephemeral storage
# This is handled in docker-compose.yml with tmpfs configuration

# Expose PostgreSQL port
EXPOSE 5432
