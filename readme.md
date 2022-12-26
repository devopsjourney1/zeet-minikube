

# Use Kubeproxy so minikube can accept outside traffic
With Zeet: Fork this repository, https://zeet.co/new/terraform
Manual: launch with `terraform up`

# SSH into the new server, grab external-kubeconfig
```
tail -f `/home/ubuntu/.kube/start.log` and wait for deployment script to finish
Copy the contents of `/home/ubuntu/.kube/external-kubeconfig` to a local file to upload to Zeet
```

# Add your Kubernetes cluster to Zeet
1. Port forward Kubernetes control plane for external access: `kubectl proxy --address='0.0.0.0' --accept-hosts='^*$' &`
2. Zeet Cluster Management: https://zeet.co/team-bradmorg/console/clusters/view
3. Upload external-kubeconfig that was generated in the last step `/home/ubuntu/.kube/external-kubeconfig`

# Deploy a Zeet application from Github
https://zeet.co/new?cpu=1&dedicated=1&memory=1&source=github


# Porforward/test the container
```
kubectl get namespace
kubectl get all -n <namespace>
kubectl port-forward service/zeet-flask-9iiv-main 3000:3000 -n 0a33e1fe-790c-4ac9-8248-f6bd12416565
curl localhost:3000
```

