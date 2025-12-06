#!/bin/bash

# Cleanup script to remove all Kubernetes resources

echo "======================================"
echo "Cleaning up Kubernetes resources..."
echo "======================================"
echo ""

echo "Deleting HPA..."
kubectl delete -f flask-hpa.yaml 2>/dev/null || echo "HPA not found"

echo "Deleting Flask Service..."
kubectl delete -f flask-service.yaml 2>/dev/null || echo "Flask Service not found"

echo "Deleting Flask Deployment..."
kubectl delete -f flask-deployment.yaml 2>/dev/null || echo "Flask Deployment not found"

echo "Deleting MongoDB Service..."
kubectl delete -f mongodb-service.yaml 2>/dev/null || echo "MongoDB Service not found"

echo "Deleting MongoDB StatefulSet..."
kubectl delete -f mongodb-statefulset.yaml 2>/dev/null || echo "MongoDB StatefulSet not found"

echo "Deleting PVC..."
kubectl delete -f mongodb-pvc.yaml 2>/dev/null || echo "PVC not found"

echo "Deleting PV..."
kubectl delete -f mongodb-pv.yaml 2>/dev/null || echo "PV not found"

echo "Deleting Secret..."
kubectl delete -f mongodb-secret.yaml 2>/dev/null || echo "Secret not found"

echo ""
echo "======================================"
echo "Cleanup complete!"
echo "======================================"
echo ""

echo "To stop Minikube:"
echo "  minikube stop"
echo ""
echo "To delete Minikube cluster:"
echo "  minikube delete"
echo ""