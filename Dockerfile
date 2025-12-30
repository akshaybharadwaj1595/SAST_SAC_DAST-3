# Stage 1: Build
FROM maven:3.8-jdk-8 AS builder

# Copy source code
COPY . /usr/src/TestProject/
WORKDIR /usr/src/TestProject/

# Build the project (skip tests for faster build)
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy WAR and start script from builder stage
COPY --from=builder /usr/src/TestProject/target/TestProject.war ./TestProject.war
COPY start.sh ./start.sh

# Make start script executable
RUN chmod +x ./start.sh

# Create logs directory
RUN mkdir -p logs

# Expose application port
EXPOSE 8080

# Run the application using start.sh
CMD ["./start.sh"]
