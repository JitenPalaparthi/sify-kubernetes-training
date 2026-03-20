- Take compelte role back up

kubectl get clusterrolebinding -o yaml > crb-backup.yaml

- take complete role binding back up

kubectl get rolebinding -A -o yaml > rb-backup.yaml

-- Another Approach 

Stop Api server port access during backup ..

# Freeze
iptables -A INPUT -p tcp --dport 6443 -j DROP

sleep 10

# Take backup
etcdctl ... snapshot save backup.db

# Resume
iptables -D INPUT -p tcp --dport 6443 -j DROP