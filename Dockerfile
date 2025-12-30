# Stage 1: Build with Maven
FROM maven:3.8-jdk-8 AS builder
COPY . /usr/src/TestProject/
WORKDIR /usr/src/TestProject/
RUN mvn -B package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy the WAR from the builder stage
COPY --from=builder /usr/src/TestProject/target/ROOT.war ./TestProject.war

# Copy start script
COPY start.sh ./start.sh
RUN chmod +x ./start.sh

# Expose application port
EXPOSE 8080

# Run the application
CMD ["./start.sh"]
