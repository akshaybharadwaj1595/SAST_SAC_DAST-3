# Build stage
FROM maven:3.8-jdk-8 AS builder

# Copy project source code
COPY . /usr/src/TestProject/
WORKDIR /usr/src/TestProject/

# Build the project with Maven
RUN mvn -B package -DskipTests

# Run stage
FROM openjdk:8-jdk-slim

# Copy the built jar from the builder stage
COPY --from=builder /usr/src/TestProject/target/TestProject.jar /

# Command to run the application
CMD ["java", "-XX:MaxMetaspaceSize=128m", "-Xloggc:logs/gc_%p_%t.log", "-Xmx256m", "-XX:MaxDirectMemorySize=90m", "-XX:+UseSerialGC", "-XX:+PrintHeapAtGC", "-XX:+PrintGCDetails", "-XX:+PrintGCDateStamps", "-XX:+UseGCLogFileRotation", "-XX:NumberOfGCLogFiles=5", "-XX:GCLogFileSize=10M", "-XX:GCTimeLimit=15", "-XX:GCHeapFreeLimit=50", "-XX:+HeapDumpOnOutOfMemoryError", "-XX:HeapDumpPath=logs/", "-XX:ErrorFile=logs/hs_err_pid%p.log", "-agentlib:jdwp=transport=dt_socket,server=y,address=9009,suspend=n", "-Dderby.stream.error.file=logs/derby.log", "-Dderby.infolog.append=true", "-Dderby.language.logStatementText=true", "-Dderby.locks.deadlockTrace=true", "-Dderby.locks.monitor=true", "-Dderby.storage.rowLocking=true", "-Dcom.sun.management.jmxremote", "-Dcom.sun.management.jmxremote.port=7900", "-Dcom.sun.management.jmxremote.ssl=false", "-Dcom.sun.management.jmxremote.authenticate=false", "-ea", "-jar", "TestProject.jar"]
