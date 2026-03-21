#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f k8s/base/00-namespace.yaml
kubectl apply -f k8s/base/01-sonarqube-postgres-secret.yaml
kubectl apply -f k8s/base/02-sonarqube-postgres-pvc.yaml
kubectl apply -f k8s/base/03-sonarqube-postgres-deployment.yaml
kubectl apply -f k8s/base/04-sonarqube-postgres-service.yaml
kubectl apply -f k8s/base/05-sonarqube-secret.yaml
kubectl apply -f k8s/base/06-sonarqube-pvc.yaml
kubectl apply -f k8s/base/07-sonarqube-deployment.yaml
kubectl apply -f k8s/base/08-sonarqube-service.yaml

echo "SonarQube resources applied."
