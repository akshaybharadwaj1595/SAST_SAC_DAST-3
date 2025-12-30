#!/bin/bash
# Start script for TestProject

# Create logs directory if it doesn't exist
mkdir -p logs

# Run the TestProject WAR file
echo "Starting TestProject on port 8080..."
java -Xmx256m \
     -XX:MaxMetaspaceSize=128m \
     -XX:+UseSerialGC \
     -XX:+PrintGCDetails \
     -XX:+PrintHeapAtGC \
     -XX:+PrintGCDateStamps \
     -jar TestProject.war \
     --server.port=8080 \
     >> logs/application.log 2>&1 &

echo "TestProject started. Logs are in logs/application.log"
