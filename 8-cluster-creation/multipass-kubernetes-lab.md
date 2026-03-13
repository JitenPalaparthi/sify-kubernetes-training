
# Kubernetes Lab Setup with Multipass

This guide sets up a Kubernetes lab environment using Multipass.

## Cluster Nodes

| Node | Purpose |
|-----|------|
| k8s-master | Kubernetes control plane |
| k8s-worker | Worker node |
| k8s-storage | NFS storage server |
| k8s-client | Kubernetes client access node |

---

# 1. Launch Multipass Instances

## Master Node

multipass launch 24.04 \
  --name k8s-master \
  --cpus 2 \
  --memory 4G \
  --disk 20G \
  --cloud-init k8s-node.yaml

## Worker Node

multipass launch 24.04 \
  --name k8s-worker \
  --cpus 2 \
  --memory 4G \
  --disk 20G \
  --cloud-init k8s-node.yaml

## Storage Node

multipass launch 24.04 \
  --name k8s-storage \
  --cpus 2 \
  --memory 2G \
  --disk 20G \
  --cloud-init storage.yaml

## Client Node

multipass launch 24.04 \
  --name k8s-client \
  --cpus 1 \
  --memory 1G \
  --disk 10G \
  --cloud-init client-node.yaml

---

# 2. Initialize Kubernetes Master

multipass ssh k8s-master

sudo kubeadm init --pod-network-cidr=10.244.0.0/16

---

# 3. Configure kubectl Access

mkdir -p $HOME/.kube

sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get nodes

---

# 4. Install Pod Network (Flannel)

kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

---

# 5. Join Worker Node

Generate join command:

kubeadm token create --print-join-command

Example:

kubeadm join 10.200.1.10:6443 --token xxx \
--discovery-token-ca-cert-hash sha256:xxxx

Run this command on the worker node.

---

# 6. Create Kubernetes Viewer User

sudo kubeadm kubeconfig user --client-name jp-viewer > jp-viewer.conf

kubectl create clusterrolebinding jp-viewer-binding \
  --clusterrole=view \
  --user=jp-viewer

---

# 7. Transfer kubeconfig to Client Node

multipass ssh k8s-client

mkdir -p ~/.kube

multipass transfer k8s-master:/home/ubuntu/jp-viewer.conf ./jp-viewer.conf

multipass exec k8s-client -- mkdir -p /home/ubuntu/.kube

multipass transfer ./jp-viewer.conf k8s-client:/home/ubuntu/.kube/config

---

# 8. Create Namespace Admin Access

kubectl create rolebinding jp-admin \
  --clusterrole=admin \
  --user=jp \
  --namespace=dev

---

# 9. Verify Client Access

multipass ssh k8s-client

kubectl get nodes
kubectl get pods -A

---

# Cluster Architecture

             +----------------+
             |   k8s-client   |
             | kubectl access |
             +--------+-------+
                      |
                      |
+-----------------------------------------------+
|              Kubernetes Cluster               |
|                                               |
|   +--------------+     +--------------+       |
|   |  k8s-master  |-----|  k8s-worker  |       |
|   | ControlPlane |     | Worker Node  |       |
|   +--------------+     +--------------+       |
|                                               |
+------------------+----------------------------+
                   |
                   |
             +-----+------+
             | k8s-storage|
             |  NFS Server|
             +------------+
