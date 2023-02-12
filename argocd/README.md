# ArgoCD Setup
This cluster also after setup uses ArgoCD for updating deployments automatically from GitHub repos.

# How To Setup
This is based off the [ArgoCD Install Guide](https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd).

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

```

At this point everything should be setup on the cluster and you need to get the initial admin password to login by running the following to decode it:

`kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.*}' | base64 -d`

This will give you the initial password.

Then you can run the following to expose the ArgoCD UI via the proxy command without having to expose it outside the cluster.

`kubectl port-forward svc/argocd-server -n argocd 8080:443`

So then you can go to https://localhost:8080 and login with user `admin` and the password from the previous get secret command.