#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="go-file-uploader:v1"

echo "Building image directly inside minikube..."
minikube image build -t "${IMAGE_NAME}" .

echo "Done. Image available to the cluster as ${IMAGE_NAME}"
