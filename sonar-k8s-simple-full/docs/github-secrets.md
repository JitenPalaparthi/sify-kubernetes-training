# GitHub secrets and variables

## Secrets

### `SONAR_HOST_URL`
Example:

```text
https://sonarqube.example.com
```

### `SONAR_TOKEN`
Generate this in SonarQube after creating your project.

### `DOCKERHUB_USERNAME`
Your Docker Hub username.

### `DOCKERHUB_TOKEN`
A Docker Hub access token.

### `KUBE_CONFIG_B64`
Base64-encoded kubeconfig used by GitHub Actions.

Example:

```bash
base64 -w 0 ~/.kube/config
```

On macOS:

```bash
base64 < ~/.kube/config | tr -d '\n'
```

### `K8S_NAMESPACE`
Example:

```text
demo-app
```

## Repository variables

### `IMAGE_REPOSITORY`
Example:

```text
mydockerhubuser/sonar-k8s-demo
```

### `APP_HOST`
Optional hostname for ingress.
