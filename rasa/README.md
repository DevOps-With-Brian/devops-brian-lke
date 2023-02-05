# Install Rasa on Kubernetes
Now that we have everything else setup, cert-manager, ingress, etc we can setup Rasa.

Add the rasa helm repo:

```
helm repo add rasa https://helm.rasa.com
helm repo update
```

Now we can install, ensure the hostname and hosts section match up with your existing dns/cert manager configuration.

`helm install -f rasa-values.yaml rasa rasa/rasa`

It might take a few mins to come up, but once so you should be able to get to it by going to https://subdomain.yourdomain.com/status will give the Rasa status info json output.