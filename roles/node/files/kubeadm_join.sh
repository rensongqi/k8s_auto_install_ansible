kubeadm join ${1}:6443 --token ${2} --discovery-token-ca-cert-hash sha256:${3} --ignore-preflight-errors=Swap
