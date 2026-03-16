multipass launch 24.04 \
  --name rancher-mgmt \
  --cpus 2 \
  --memory 4G \
  --disk 20G \
  --cloud-init cloud-init-rancher.yaml