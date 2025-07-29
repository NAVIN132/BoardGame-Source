# Use Java 11 base image
FROM openjdk:11-jdk-slim

# Set working directory
WORKDIR /app

# Copy the built jar
COPY target/database_service_project-*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
