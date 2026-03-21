#!/usr/bin/env bash
set -euo pipefail
kubectl -n sonarqube rollout status deployment/sonarqube --timeout=300s
kubectl -n sonarqube get pods -o wide
