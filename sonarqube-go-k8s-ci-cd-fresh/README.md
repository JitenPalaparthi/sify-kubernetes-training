# SonarQube + Golang + Kubernetes + GHCR CI/CD

This is a plain-YAML starter project for:
- SonarQube deployed in Kubernetes
- PostgreSQL for SonarQube
- A sample Go web app
- GitHub Actions CI/CD
- SonarQube analysis + Quality Gate
- GHCR image build/push
- Kubernetes app deployment

## Quick start

1. Deploy SonarQube:
```bash
kubectl apply -f k8s/sonarqube/00-namespace.yaml
kubectl apply -f k8s/sonarqube/01-postgres-secret.yaml
kubectl apply -f k8s/sonarqube/02-postgres-pvc.yaml
kubectl apply -f k8s/sonarqube/03-postgres-deployment.yaml
kubectl apply -f k8s/sonarqube/04-postgres-service.yaml
kubectl apply -f k8s/sonarqube/05-sonarqube-secret.yaml
kubectl apply -f k8s/sonarqube/06-sonarqube-pvc.yaml
kubectl apply -f k8s/sonarqube/07-sonarqube-deployment.yaml
kubectl apply -f k8s/sonarqube/08-sonarqube-service.yaml
```

2. Port-forward SonarQube:
```bash
kubectl -n sonarqube port-forward svc/sonarqube 9000:9000
```

3. Open `http://localhost:9000`, create a project/token.

4. Push this repo to GitHub and add these secrets:
- `SONAR_HOST_URL`
- `SONAR_TOKEN`
- `KUBE_CONFIG_B64`

5. Push to `main` to trigger CI/CD.

## Important
GitHub-hosted runners must be able to reach your SonarQube URL.
