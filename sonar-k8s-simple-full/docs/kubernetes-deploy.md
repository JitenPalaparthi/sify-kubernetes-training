# Kubernetes deployment notes

## Namespaces used

- `sonarqube` for SonarQube and PostgreSQL
- `demo-app` or your chosen namespace for the sample application

## Storage

This starter uses simple PVC objects without a StorageClass override. If your cluster requires an explicit storage class, update the PVC manifests.

## Ingress

The included ingress examples assume an ingress controller already exists in the cluster.

## Security

For a real environment:

- move plaintext secrets into Sealed Secrets, External Secrets, or your secret manager,
- add network policies,
- add TLS,
- restrict ingress,
- use a proper image registry secret if the image is private.
