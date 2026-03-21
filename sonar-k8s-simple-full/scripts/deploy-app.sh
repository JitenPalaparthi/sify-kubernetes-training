#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <namespace> <image>"
  exit 1
fi

NAMESPACE="$1"
IMAGE="$2"

kubectl get ns "$NAMESPACE" >/dev/null 2>&1 || kubectl create ns "$NAMESPACE"

sed "s#__NAMESPACE__#$NAMESPACE#g" k8s/base/09-app-configmap.yaml | kubectl apply -f -
sed \
  -e "s#__NAMESPACE__#$NAMESPACE#g" \
  -e "s#__IMAGE__#$IMAGE#g" \
  k8s/base/10-app-deployment.yaml | kubectl apply -f -
sed "s#__NAMESPACE__#$NAMESPACE#g" k8s/base/11-app-service.yaml | kubectl apply -f -

echo "App deployed to namespace: $NAMESPACE"
