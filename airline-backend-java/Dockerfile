# Build stage
FROM maven:3.9.6-amazoncorretto-17 AS build
WORKDIR /workspace/app

COPY pom.xml .
COPY src src

RUN mvn clean package -DskipTests

# Run stage
FROM amazoncorretto:17

# Create app directory and temp directories
WORKDIR /app
RUN mkdir -p /app/tmp/tomcat

# Copy application
COPY --from=build /workspace/app/target/*.jar app.jar

# Set permissions for non-root user
RUN chown -R 1000:1000 /app && \
    chmod -R 755 /app

# Switch to non-root user
USER 1000

# Configure Tomcat temp directory
ENV JAVA_OPTS="-Djava.io.tmpdir=/app/tmp/tomcat"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
