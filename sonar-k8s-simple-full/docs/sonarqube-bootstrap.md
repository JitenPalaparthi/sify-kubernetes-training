# SonarQube bootstrap

1. Deploy PostgreSQL and SonarQube.
2. Port-forward or expose SonarQube via ingress.
3. Log in with the default bootstrap flow.
4. Create a project named `sonar-k8s-demo`.
5. Generate a user token.
6. Add that token to GitHub as `SONAR_TOKEN`.
7. Add SonarQube URL as `SONAR_HOST_URL`.

## Reachability requirement

GitHub-hosted runners must be able to reach the SonarQube URL. If your cluster is private-only, use:

- a self-hosted GitHub runner inside the network, or
- a secure public ingress / VPN / tunnel design approved by your organization.
