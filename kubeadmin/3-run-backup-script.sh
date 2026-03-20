#!/usr/bin/env bash
chmod +x etcd-remote-backup.sh

ENDPOINT=https://192.168.2.32:2379 \
KUBECONFIG_PATH=/home/ubuntu/.kube/config \
./etcd-remote-backup.sh
