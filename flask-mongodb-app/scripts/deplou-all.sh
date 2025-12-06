#!/bin/bash

# Complete deployment script for Flask-MongoDB app on Kubernetes

echo "======================================"
echo "Flask-MongoDB Kubernetes Deployment"
echo "======================================"
echo ""

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed"
    exit 1
fi

# Check if minikube is running
if ! minikube status &> /dev/null; then
    echo "Starting Minikube..."
    minikube start --cpus=4 --memory=4096
    echo "Enabling metrics-server addon..."
    minikube addons enable metrics-server
fi

echo "Step 1: Creating MongoDB Secret..."
kubectl apply -f mongodb-secret.yaml
echo "✓ Secret created"
echo ""

echo "Step 2: Creating Persistent Volume and Claim..."
kubectl apply -f mongodb-pv.yaml
kubectl apply -f mongodb-pvc.yaml
echo "✓ PV and PVC created"
echo ""

echo "Step 3: Deploying MongoDB StatefulSet..."
kubectl apply -f mongodb-statefulset.yaml
echo "Waiting for MongoDB to be ready..."
kubectl wait --for=condition=ready pod -l app=mongodb --timeout=120s
echo "✓ MongoDB deployed and ready"
echo ""

echo "Step 4: Creating MongoDB Service..."
kubectl apply -f mongodb-service.yaml
echo "✓ MongoDB service created"
echo ""

echo "Step 5: Deploying Flask Application..."
kubectl apply -f flask-deployment.yaml
echo "Waiting for Flask pods to be ready..."
kubectl wait --for=condition=ready pod -l app=flask-app --timeout=120s
echo "✓ Flask app deployed and ready"
echo ""

echo "Step 6: Creating Flask Service..."
kubectl apply -f flask-service.yaml
echo "✓ Flask service created"
echo ""

echo "Step 7: Setting up Horizontal Pod Autoscaler..."
kubectl apply -f flask-hpa.yaml
echo "✓ HPA configured"
echo ""

echo "======================================"
echo "Deployment Complete!"
echo "======================================"
echo ""

# Get Minikube IP and service URL
MINIKUBE_IP=$(minikube ip)
echo "Minikube IP: $MINIKUBE_IP"
echo "Application URL: http://$MINIKUBE_IP:30080"
echo ""

echo "Useful commands:"
echo "  kubectl get all                    # View all resources"
echo "  kubectl get pods                   # View pods"
echo "  kubectl get hpa                    # View autoscaler status"
echo "  kubectl logs -f <pod-name>         # View logs"
echo "  minikube service flask-service     # Get service URL"
echo ""

echo "Test the application:"
echo "  curl http://$MINIKUBE_IP:30080/"
echo "  curl -X POST -H 'Content-Type: application/json' -d '{\"test\":\"data\"}' http://$MINIKUBE_IP:30080/data"
echo "  curl http://$MINIKUBE_IP:30080/data"
echo ""