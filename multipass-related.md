sudo launchctl bootout system /Library/LaunchDaemons/com.canonical.multipassd.plist 2>/dev/null
sudo launchctl bootstrap system /Library/LaunchDaemons/com.canonical.multipassd.plist
sudo launchctl kickstart -k system/com.canonical.multipassd
multipass list


kubeadm join 192.168.2.2:6443 --token j7v689.cdtqj16d7sd3nwnj \
	--discovery-token-ca-cert-hash sha256:0e572d045120c573af0eb84d57b2af5115fe467e9f2fc2e8e46d83658c025b76 

    sudo kubeadm join 192.168.2.2:6443 --token lq59wa.f7d8b6xynz22km3c --discovery-token-ca-cert-hash sha256:0e572d045120c573af0eb84d57b2af5115fe467e9f2fc2e8e46d83658c025b76 
