

# Use Kubeproxy so minikube can accept outside traffic
With Zeet: Fork this repository, https://zeet.co/new/terraform
Manual: launch with `terraform up`

# Create a Service Account, Bind clusteradminrole, Generate Password, Generate Kubeconfig
```
kubectl create serviceaccount externalserviceacct
kubectl create clusterrolebinding externalrolebinding --serviceaccount=default:externalserviceacct --clusterrole=admin
cp ~/.kube/config external-kubeconfig
TOKEN=$(kubectl create token externalserviceacct)
EXTERNAL_URL=https://$(curl ifconfig.me):8001
kubectl config set-cluster minikube --kubeconfig=external-kubeconfig --insecure-skip-tls-verify=true --server=$EXTERNAL_URL
kubectl config set-credentials minikube --kubeconfig=external-kubeconfig --username=externalserviceacct --password=$TOKEN
kubectl config set-credentials minikube --kubeconfig=external-kubeconfig --username=externalserviceacct
kubectl config unset users.minikube.client-certificate  --kubeconfig=external-kubeconfig
kubectl config unset users.minikube.client-key --kubeconfig=external-kubeconfig
kubectl get all --kubeconfig external-kubeconfig
```


# Add your Kubernetes cluster to Zeet
Port forward Kubernetes control plane for external access: `kubectl proxy --address='0.0.0.0' --accept-hosts='^*$'`
Point Zeet to your cluster: https://zeet.co/team-bradmorg/console/clusters/view
Upload external-kubeconfig  that was generated in the last step

# Deploy a Zeet application from Github
https://zeet.co/new?cpu=1&dedicated=1&memory=1&source=github


# Porforward/test the container
```
kubectl get namespace
kubectl get all -n <namespace>
kubectl port-forward service/zeet-flask-9iiv-main 3000:3000 -n 0a33e1fe-790c-4ac9-8248-f6bd12416565
curl localhost:3000
```

