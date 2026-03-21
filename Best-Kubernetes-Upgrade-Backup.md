- Take the backup of your ETCD 

ETCDCTL_API=3 etcdctl \
--endpoints=https://127.0.0.1:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /root/etcd-backup-$(date +%F).db

- verify the back 
- etcdctl snapshot status /root/etcd-backup-*.db

- Upgrade the minior versions

- 1.30 --> 1.31 but not 1.35(very dangerous)

- Upgrade the master node (control plane) first 

- update kubeadm first with the latest version (compatiable version),
    - check kuberentes.io documentation and version information

- sudo kubeadm upgrade plan

- sudo kubeadm upgrade apply 1.31.*

- above command gives you information, any manual upgrades are there work on that..
- Unless you understand all manual updates what to do , dont go for the upgrade

- upgrade the kubelet --> sudo apt install kubelet=1.31.* kubectl=1.31.*

- restart the kubelet --> sudo systemctl restart kubelet

- kubectl get nodes 

- Upgrade the worker nodes

- kubectl drain worker1 --ignore-daemonsets --delete-emptydir-data
- kubectl cordon worker1