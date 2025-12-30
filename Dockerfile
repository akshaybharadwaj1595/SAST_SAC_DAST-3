# Stage 1: Build WAR with Maven
FROM maven:3.8-jdk-8 AS builder
WORKDIR /usr/src/TestProject
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime using Eclipse Temurin
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy WAR from builder
COPY --from=builder /usr/src/TestProject/target/ROOT.war ./TestProject.war

# Copy start script
COPY start.sh ./start.sh
RUN chmod +x ./start.sh

EXPOSE 8080

CMD ["./start.sh"]
