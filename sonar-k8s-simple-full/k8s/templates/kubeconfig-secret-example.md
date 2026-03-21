# Example: generate KUBE_CONFIG_B64 for GitHub Actions

```bash
base64 -w 0 ~/.kube/config
```

On macOS:

```bash
base64 < ~/.kube/config | tr -d '\n'
```
