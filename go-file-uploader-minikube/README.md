# Go File Uploader for Minikube

This project contains a simple Go web application that uploads files and stores them using three Kubernetes-backed storage patterns:

1. `emptyDir` — files live inside the pod lifecycle only.
2. `hostPath` — files are stored on the node filesystem.
3. Shared PVC via NFS (`ReadWriteMany`) — files stay available even if the pod moves to another node.

## App behavior

- `GET /` shows an upload form and lists uploaded files.
- `POST /upload` stores the file in `/data/uploads`.
- `GET /files/<name>` serves uploaded files back.

## Build image for Minikube

Minikube supports building images directly inside the cluster runtime with `minikube image build`. 
See the Minikube command reference. 

```bash
cd go-file-uploader-minikube
./scripts/build-and-load.sh
```

Alternative:

```bash
minikube image build -t go-file-uploader:v1 .
```

## Deploy base namespace

```bash
kubectl apply -f k8s/00-namespace.yaml
```

## Option 1: store inside the pod (`emptyDir`)

Kubernetes creates `emptyDir` when the pod is assigned to a node, and the data is deleted permanently when the pod is removed from that node. 

```bash
kubectl apply -f k8s/01-emptydir-deployment.yaml
minikube service uploader-emptydir -n upload-demo --url
```

Open the returned URL in the browser and upload a file.

To verify data is ephemeral:

```bash
kubectl delete pod -n upload-demo -l app=uploader-emptydir
```

After the replacement pod starts, the uploaded files are gone.

## Option 2: store on the node (`hostPath`)

`hostPath` mounts a directory from the node filesystem into the pod. Kubernetes documents `hostPath` mainly for development/testing; in production clusters you typically avoid it as the general solution. citeturn264520search9turn264520search2

```bash
kubectl apply -f k8s/02-hostpath-deployment.yaml
minikube service uploader-hostpath -n upload-demo --url
```

Verify on the Minikube node:

```bash
minikube ssh
sudo ls -lah /var/lib/minikube-uploads
```

The files survive pod restart as long as the app lands on the same node.

## Option 3: shared persistent volume for any node (PVC backed by NFS)

Minikube supports hostPath-backed persistent volumes out of the box, but those are mapped inside the Minikube instance and are not the same thing as a shared cross-node RWX volume. citeturn264520search1

For your "available for any node" requirement, this project uses a simple in-cluster NFS server plus a `ReadWriteMany` PVC.

```bash
kubectl apply -f k8s/03-nfs-shared-storage.yaml
minikube service uploader-pvc -n upload-demo --url
```

Verify PVC and PV:

```bash
kubectl get pvc,pv -n upload-demo
```

Force the uploader pod to move and keep the same data:

```bash
kubectl get pods -n upload-demo -o wide
kubectl delete pod -n upload-demo -l app=uploader-pvc
kubectl get pods -n upload-demo -o wide
```

The files should still be listed after the new pod starts because the PVC is mounted again.

## Notes on production

- `emptyDir` is only for pod-local ephemeral storage. citeturn264520search2
- `hostPath` is node-local and usually only for development/testing or very controlled node-specific workloads. citeturn264520search9
- For true production-grade shared storage, prefer a real CSI-backed storage platform such as NFS CSI, Ceph/Rook, Longhorn, or OpenEBS, depending on your HA and performance needs.

## Cleanup

```bash
kubectl delete namespace upload-demo
```
