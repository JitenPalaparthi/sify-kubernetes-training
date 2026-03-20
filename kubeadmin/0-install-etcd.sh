#!/usr/bin/env bash
set -Eeuo pipefail

# Example (Linux)
ETCD_VERSION=v3.5.13
wget https://github.com/etcd-io/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz
tar -xvf etcd-${ETCD_VERSION}-linux-amd64.tar.gz
sudo mv etcd-${ETCD_VERSION}-linux-amd64/etcdctl /usr/local/bin/