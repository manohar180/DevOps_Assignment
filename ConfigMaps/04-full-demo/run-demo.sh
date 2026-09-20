#!/bin/bash
set -e

echo "=== Applying Yatri Lecture 12 demo ==="

kubectl apply -f 04-full-demo/all-in-one.yaml

echo
echo "=== Waiting for deployments ==="

kubectl rollout status deployment/yatri-backend
kubectl rollout status deployment/yatri-frontend

echo
echo "=== Demo resources ==="

kubectl get configmap yatri-app-config
kubectl get secret yatri-db-secret
kubectl get deployments
kubectl get services
kubectl get ingress
kubectl get pods -l app=yatri-app

echo
echo "=== Demo deployment completed ==="
