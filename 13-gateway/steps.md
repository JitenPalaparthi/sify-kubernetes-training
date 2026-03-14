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



- create self signed certificate (only for dev and testing)

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=demo.local/O=demo.local"
```

- create secret 

```bash
kubectl create secret tls demo-tls --cert=tls.crt --key=tls.key -n demo
```

6. run 02-gateway.yaml

7. get external ip

```bash
kubectl get gateway demo-gateway -n demo
```

8. Test by calling 

```bash
 curl -vk --resolve demo.local:443:10.38.154.240 https://demo.local/a
 curl -vk --resolve demo.local:443:10.38.154.240 https://demo.local/b
 # The ip need to be ecxternal --> metallb gives the ip  
```

