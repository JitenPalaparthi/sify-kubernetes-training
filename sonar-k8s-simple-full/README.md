# SonarQube + GitHub Actions + Kubernetes (No Helm)

This repository is a **full, GitHub-ready starter project** that shows how to:

1. run a sample Go microservice,
2. analyze it with **SonarQube** in GitHub Actions,
3. build a container image,
4. deploy the application to a Kubernetes cluster using plain YAML manifests,
5. optionally deploy **SonarQube itself** into Kubernetes using plain YAML manifests and PostgreSQL.

## What this repo contains

- `app/` — sample Go REST API
- `.github/workflows/ci-cd.yaml` — GitHub Actions pipeline
- `k8s/base/` — plain Kubernetes manifests for:
  - PostgreSQL for SonarQube
  - SonarQube server
  - sample app deployment/service
- `k8s/templates/` — templates you should customize before applying
- `scripts/` — helper scripts for local deploy/use
- `docs/` — setup notes

## Architecture

- **SonarQube server** runs inside Kubernetes and connects to PostgreSQL.
- **GitHub Actions** builds and tests the Go app, uploads coverage to SonarQube, builds a Docker image, and deploys the app to Kubernetes.
- The app is deployed separately from SonarQube.

## Important operational note

For GitHub-hosted runners to reach SonarQube, `SONAR_HOST_URL` must be reachable from GitHub Actions, typically through an ingress or public endpoint with authentication/TLS as needed. SonarQube’s Docker/container setup is configured through environment variables such as `SONAR_JDBC_URL`, `SONAR_JDBC_USERNAME`, and `SONAR_JDBC_PASSWORD`, and SonarSource documents GitHub Actions integration through its SonarQube Scan action. citeturn672781search0turn672781search1turn672781search3

## Repository layout

```text
.
├── .github/workflows/ci-cd.yaml
├── app/
│   ├── cmd/server/main.go
│   ├── internal/handlers/health.go
│   ├── internal/version/version.go
│   ├── go.mod
│   ├── go.sum
│   ├── Dockerfile
│   ├── sonar-project.properties
│   └── main_test.go
├── docs/
│   ├── github-secrets.md
│   ├── kubernetes-deploy.md
│   └── sonarqube-bootstrap.md
├── k8s/
│   ├── base/
│   │   ├── 00-namespace.yaml
│   │   ├── 01-sonarqube-postgres-secret.yaml
│   │   ├── 02-sonarqube-postgres-pvc.yaml
│   │   ├── 03-sonarqube-postgres-deployment.yaml
│   │   ├── 04-sonarqube-postgres-service.yaml
│   │   ├── 05-sonarqube-secret.yaml
│   │   ├── 06-sonarqube-pvc.yaml
│   │   ├── 07-sonarqube-deployment.yaml
│   │   ├── 08-sonarqube-service.yaml
│   │   ├── 09-app-configmap.yaml
│   │   ├── 10-app-deployment.yaml
│   │   ├── 11-app-service.yaml
│   │   └── 12-app-ingress.yaml
│   └── templates/
│       ├── github-registry-pull-secret.yaml
│       ├── kubeconfig-secret-example.md
│       └── sonarqube-ingress.yaml
└── scripts/
    ├── deploy-sonarqube.sh
    ├── deploy-app.sh
    └── wait-for-sonarqube.sh
```

## Quick start

### 1. Deploy SonarQube into Kubernetes

```bash
kubectl apply -f k8s/base/00-namespace.yaml
kubectl apply -f k8s/base/01-sonarqube-postgres-secret.yaml
kubectl apply -f k8s/base/02-sonarqube-postgres-pvc.yaml
kubectl apply -f k8s/base/03-sonarqube-postgres-deployment.yaml
kubectl apply -f k8s/base/04-sonarqube-postgres-service.yaml
kubectl apply -f k8s/base/05-sonarqube-secret.yaml
kubectl apply -f k8s/base/06-sonarqube-pvc.yaml
kubectl apply -f k8s/base/07-sonarqube-deployment.yaml
kubectl apply -f k8s/base/08-sonarqube-service.yaml
```

Optional ingress:

```bash
kubectl apply -f k8s/templates/sonarqube-ingress.yaml
```

### 2. Log into SonarQube and create a project/token

After SonarQube starts:

```bash
kubectl -n sonarqube port-forward svc/sonarqube 9000:9000
```

Open `http://localhost:9000`, bootstrap your admin user, create a project, and generate a token.

### 3. Add GitHub secrets

Required repository secrets:

- `SONAR_HOST_URL`
- `SONAR_TOKEN`
- `KUBE_CONFIG_B64`
- `K8S_NAMESPACE`
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

Optional variables:

- `IMAGE_REPOSITORY`
- `APP_HOST`

### 4. Push to GitHub

The workflow will:

- run unit tests,
- generate coverage,
- run SonarQube scan,
- build and push the container image,
- deploy the app to Kubernetes.

## Notes

- The official SonarQube Docker image is published through Docker Hub. citeturn672781search2
- SonarSource documents GitHub Actions integration for SonarQube and notes the current GitHub Action / Scanner CLI behavior, including Java 21 in recent scanner packaging. citeturn672781search1turn672781search13turn672781search18

