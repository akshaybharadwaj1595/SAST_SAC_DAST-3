# -------------------------
# Build stage
# -------------------------
FROM maven:3.6.3-jdk-8 AS builder

# Copy project source to container
COPY . /usr/src/TestProject/
WORKDIR /usr/src/TestProject/

# Build project and produce jar
RUN mvn -B package -DskipTests

# -------------------------
# Run stage
# -------------------------
FROM openjdk:8-jdk

# Create logs directory
RUN mkdir -p /logs

# Copy application jar from build stage
COPY --from=builder /usr/src/TestProject/target/TestProject.jar /

# Run command with JVM options
CMD ["java", \
     "-XX:MaxMetaspaceSize=128m", \
     "-Xloggc:/logs/gc_%p_%t.log", \
     "-Xmx256m", \
     "-XX:+UseSerialGC", \
     "-XX:+PrintHeapAtGC", \
     "-XX:+PrintGCDetails", \
     "-XX:+PrintGCDateStamps", \
     "-XX:+UseGCLogFileRotation", \
     "-XX:NumberOfGCLogFiles=5", \
     "-XX:GCLogFileSize=10M", \
     "-XX:+HeapDumpOnOutOfMemoryError", \
     "-XX:HeapDumpPath=/logs/", \
     "-XX:ErrorFile=/logs/hs_err_pid%p.log", \
     "-agentlib:jdwp=transport=dt_socket,server=y,address=9009,suspend=n", \
     "-Dderby.stream.error.file=/logs/derby.log", \
     "-Dderby.infolog.append=true", \
     "-Dderby.language.logStatementText=true", \
     "-Dderby.locks.deadlockTrace=true", \
     "-Dderby.locks.monitor=true", \
     "-Dderby.storage.rowLocking=true", \
     "-Dcom.sun.management.jmxremote", \
     "-Dcom.sun.management.jmxremote.port=7900", \
     "-Dcom.sun.management.jmxremote.ssl=false", \
     "-Dcom.sun.management.jmxremote.authenticate=false", \
     "-ea", \
     "-jar", "TestProject.jar"]
