multipass launch 24.04 --name k8s-master --cpus 2 --memory 4G --disk 20G --cloud-init master-cloud-init.yaml

multipass launch 24.04 --name k8s-worker --cpus 4 --memory 12G --disk 20G --cloud-init worker-cloud-init.yaml

multipass launch 24.04 --name k8s-client --cpus 2 --memory 4G --disk 20G --cloud-init client-node.yaml


multipass transfer k8s-master:/home/ubuntu/join-worker.sh k8s-worker:/home/ubuntu/join-worker.sh

multipass transfer k8s-master:/home/ubuntu/join-worker.sh . && \
multipass transfer ./join-worker.sh k8s-worker:/home/ubuntu/join-worker.sh


k8s-client              Running           10.38.154.229    Ubuntu 24.04 LTS
                                          172.17.0.1
k8s-master              Running           10.38.154.25     Ubuntu 24.04 LTS
                                          10.244.0.0
                                          10.244.0.1
k8s-worker              Running           10.38.154.233    Ubuntu 24.04 LTS
                                          10.244.1.0

