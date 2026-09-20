#!/bin/bash
set -e

echo "=== Cleaning up Lecture 12 resources ==="

kubectl delete ingress yatri-ingress --ignore-not-found
kubectl delete ingress campus-host-ingress --ignore-not-found
kubectl delete ingress campus-ingress-tls --ignore-not-found

kubectl delete service yatri-frontend yatri-backend --ignore-not-found

kubectl delete deployment yatri-frontend yatri-backend --ignore-not-found

kubectl delete secret campus-tls-cert yatri-db-secret --ignore-not-found

kubectl delete configmap yatri-app-config --ignore-not-found

echo
echo "=== Lecture 12 cleanup completed ==="
