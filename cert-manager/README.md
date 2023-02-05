# Setting Up Cert Manager/Used for HTTPS
Ensure you already have your dns nameservers from domain pointing to the linode servers and resolving before performing these steps.  Also ensure you already ran the terraform in the `dns` folder to setup the domain and such.

Install Cert Manager CRDs:

`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.crds.yaml`

Add helm repo:

`helm repo add cert-manager https://charts.jetstack.io`
`helm repo update`

Install cert-manager helm chart:

`helm install my-cert-manager cert-manager/cert-manager --namespace cert-manager --version v1.8.0`

Validate cert-manager pods are running:

`kubectl get pods --namespace cert-manager`

Next up you need to set a env var `export EMAIL=xxx@xxx.com` that will be used for the let's encrypt verification and such.  After setting this you can install the `acme-issuer` via:

`envsubst < acme-issuer-prod.yaml | kubectl apply -f -`
