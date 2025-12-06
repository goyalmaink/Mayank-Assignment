#!/bin/bash

# Load testing script to test HPA
# This script generates load on the Flask application

MINIKUBE_IP=$(minikube ip)
SERVICE_PORT=30080
URL="http://$MINIKUBE_IP:$SERVICE_PORT"

echo "Starting load test on $URL"
echo "Press Ctrl+C to stop"

# Generate concurrent requests
for i in {1..1000}; do
  curl -s "$URL/" > /dev/null &
  curl -s -X POST -H "Content-Type: application/json" \
    -d '{"test":"data","iteration":"'$i'"}' \
    "$URL/data" > /dev/null &
  
  # Add slight delay to prevent overwhelming the system immediately
  if [ $((i % 10)) -eq 0 ]; then
    sleep 0.1
  fi
done

wait
echo "Load test completed"