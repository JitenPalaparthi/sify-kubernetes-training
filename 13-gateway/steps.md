1. Install MetaLLB

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml

2. Get IP Address Range for MetaLLB 
    


k8s-client  192.168.2.10 
k8s-master  192.168.2.7 
k8s-storage 192.168.2.9     
k8s-worker  192.168.2.8      

Address-Range: 192.168.2.40-192.168.2.50

3. Run 00-metallb-config.yaml

4. Install Envoy

```bash
helm install eg oci://docker.io/envoyproxy/gateway-helm \
  --version v1.3.3 \
  -n envoy-gateway-system \
  --create-namespace
  ```

5. run 01-deployments.yaml

6. run 03-gateway.yaml

7. get external ip

```bash
kubectl get gateway demo-gateway -n demo
```

8. Test by calling 

```bash
curl -H "Host: demo.local" http://192.168.2.240/a
curl -H "Host: demo.local" http://192.168.2.240/b
```

