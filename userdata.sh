#!/bin/bash
# Minikube install
echo "installing Minikube.." >> /home/ubuntu/start.log
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Kubectl install
echo "installing Kubectl.." >> /home/ubuntu/start.log
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Docker install
echo "installing Docker.." >> /home/ubuntu/start.log
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo usermod -aG docker ubuntu && newgrp docker

# Start Minikube as non-root user "ubuntu"
echo "starting Minikube" >> /home/ubuntu/start.log
runuser -l ubuntu -c "minikube start"

# Create a Service Account, Bind admin clusterrole, Generate Password
echo "creating kubeconfig at /home/ubuntu/.kube/external-kubeconfig" >> /home/ubuntu/start.log
sudo -u ubuntu -i <<'EOF'
kubectl create serviceaccount externalserviceacct
kubectl create clusterrolebinding externalrolebinding --serviceaccount=default:externalserviceacct --clusterrole=admin
cd ~/.kube/
cp ~/.kube/config ~/.kube/external-kubeconfig
TOKEN=$(kubectl create token externalserviceacct)
EXTERNAL_URL=http://$(curl ifconfig.me):8001
kubectl config set-cluster minikube --kubeconfig=external-kubeconfig --insecure-skip-tls-verify=true --server=$EXTERNAL_URL
kubectl config set-credentials minikube --kubeconfig=external-kubeconfig --username=externalserviceacct --password=$TOKEN
kubectl config set-credentials minikube --kubeconfig=external-kubeconfig --username=externalserviceacct
kubectl config unset users.minikube.client-certificate  --kubeconfig=external-kubeconfig
kubectl config unset users.minikube.client-key --kubeconfig=external-kubeconfig
cp ~/.kube/external-kubeconfig ~/external-kubeconfig
EOF


# Setup proxy to receive connections from all IPs on port 8001
#kubectl proxy --address='0.0.0.0' --accept-hosts='^*$'

echo "start script complete" >> /home/ubuntu/start.log
