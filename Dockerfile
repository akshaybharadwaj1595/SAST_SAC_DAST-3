# Stage 1: Build
FROM maven:3.8-jdk-8 AS builder
COPY . /usr/src/TestProject/
WORKDIR /usr/src/TestProject/
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

COPY --from=builder /usr/src/TestProject/target/TestProject.war ./TestProject.war
COPY start.sh ./start.sh
RUN chmod +x ./start.sh

EXPOSE 8080
CMD ["./start.sh"]
