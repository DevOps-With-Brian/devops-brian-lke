*******************
Cert Manager Setup
*******************
This section will go over how to get cert manager setup on your kubernetes cluster to allow for automated SSL certificates from Let's Encrypt.

More information can be found at `Linode TLS Encryption Guide Kubernetes <https://www.linode.com/docs/guides/how-to-configure-load-balancing-with-tls-encryption-on-a-kubernetes-cluster/>`_ or at `Cert Manager Install <https://cert-manager.io/docs/installation/>`_

Ensure you are in the ``cert-manager`` directory for all of these steps.

.. note::
    Be sure before starting any of the below steps you already have your dns nameservers from your custom domain pointing to the linode servers and resolving, this should have been done in the previous dns terraform steps.

Install Helm
------------
Now that our cluster is setup, we need to install helm before we can run the below commands to setup the cluster.

Helm is a package manager for Kubernetes, please check out `Install Instructions For Helm <https://helm.sh/docs/intro/install/>`_ on how to install it.


Install Cert Manager CRDs
-------------------------
Ensure you have your `lke-cluster-config.yaml` file from the previous kubernetes section exported, and then you will want to run the following to install the cert manager CRDs::

    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.crds.yaml

We should see something like this::

    customresourcedefinition.apiextensions.k8s.io/certificaterequests.cert-manager.io created
    customresourcedefinition.apiextensions.k8s.io/certificates.cert-manager.io created
    customresourcedefinition.apiextensions.k8s.io/challenges.acme.cert-manager.io created
    customresourcedefinition.apiextensions.k8s.io/clusterissuers.cert-manager.io created
    customresourcedefinition.apiextensions.k8s.io/issuers.cert-manager.io created
    customresourcedefinition.apiextensions.k8s.io/orders.acme.cert-manager.io created


Install Cert Manager
--------------------
Now we can add our cert-manager helm repo and update it then install it::

    helm repo add cert-manager https://charts.jetstack.io

    helm repo update

    helm install my-cert-manager cert-manager/cert-manager --namespace cert-manager --version v1.8.0

If successful we should see something like this::

    NAME: my-cert-manager
    LAST DEPLOYED: Mon Nov 21 06:39:07 2022
    NAMESPACE: cert-manager
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    NOTES:
    cert-manager v1.8.0 has been deployed successfully!

    In order to begin issuing certificates, you will need to set up a ClusterIssuer
    or Issuer resource (for example, by creating a 'letsencrypt-staging' issuer).

    More information on the different types of issuers and how to configure them
    can be found in our documentation:

    https://cert-manager.io/docs/configuration/

    For information on how to configure cert-manager to automatically provision
    Certificates for Ingress resources, take a look at the `ingress-shim`
    documentation:

    https://cert-manager.io/docs/usage/ingress/

Now verify you see the corresponding pods coming up and running::

    kubectl get pods --namespace cert-manager

You should see something like::

    NAME                                       READY   STATUS    RESTARTS   AGE
    cert-manager-579d48dff8-84nw9              1/1     Running   3          1m
    cert-manager-cainjector-789955d9b7-jfskr   1/1     Running   3          1m
    cert-manager-webhook-64869c4997-hnx6n      1/1     Running   0          1m

.. note::
    Before continuing to the next steps ensure these cert-manager pods are running and ready.


Setting Up ClusterIssuer Resource
---------------------------------
Next we will be creating a cluster issuer resource that will be in charge of helping with the automated ssl certs.

This manifest we are about to install will register an account on an ACME server used by Let's Encrypt for the certificates.

To secure the email we have set this up as a export instead of an actual terraform tfvar.  So we need to export our email address we want to use with Let's Encrypt to issue the certificates automatically.

Once you know what this email should be run the following::

    export EMAIL=xxx@xxx.com
    envsubst < acme-issuer-prod.yaml | kubectl apply -f -

This will update the email section of that file for you automatically and apply it.

We should now have everything we need setup in order to deploy our test application.  In this setup we are using a rasa chatbot atm for a demo example.  Please proceed to the next Rasa Demo Setup section to see how this works.


.. note::
    Before starting the next part, I like to wait about 10-15 mins for everything DNS wise to setup and replicate so you don't run into issues.
