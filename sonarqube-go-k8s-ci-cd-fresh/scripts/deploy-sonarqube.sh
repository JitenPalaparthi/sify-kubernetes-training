#!/usr/bin/env bash
set -euo pipefail
kubectl apply -f k8s/sonarqube/00-namespace.yaml
kubectl apply -f k8s/sonarqube/00a-postgres-pv.yaml
kubectl apply -f k8s/sonarqube/00b-sonarqube-pv.yaml
kubectl apply -f k8s/sonarqube/01-postgres-secret.yaml
kubectl apply -f k8s/sonarqube/02-postgres-pvc.yaml
kubectl apply -f k8s/sonarqube/03-postgres-deployment.yaml
kubectl apply -f k8s/sonarqube/04-postgres-service.yaml
kubectl apply -f k8s/sonarqube/05-sonarqube-secret.yaml
kubectl apply -f k8s/sonarqube/06-sonarqube-pvc.yaml
kubectl apply -f k8s/sonarqube/07-sonarqube-deployment.yaml
kubectl apply -f k8s/sonarqube/08-sonarqube-service.yaml
