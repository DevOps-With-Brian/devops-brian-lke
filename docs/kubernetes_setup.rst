*****************
Kubernetes Setup
*****************
This section outlines how to setup the Linode LKE cluster via Terraform code.  All of the steps below will be ran from the ``lke`` directory. 


Linode API Token
----------------
We will need a Linode API token in order for this to work and be able to setup the resources.  You can find a how to located at https://www.linode.com/docs/guides/getting-started-with-the-linode-api/

The scopes you need to give it access to are:

.. parsed-literal::

    Domains - Read/Write
    Kubernetes - Read/Write
    IPs - Read/Write
    Linodes - Read/Write

This API token will become the ``TF_VAR_token`` mentioned in the next section.

Terraform Cloud Token
---------------------
Don't forget this repo uses remote state located in Terraform Cloud, more information can be found at https://www.hashicorp.com/products/terraform/pricing.
Currently using the Free tier and setup an account for free.  After setting up a free account you will want to generate an API token as discussed in https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login before we can continue.


Terraform Variables
-------------------
The first thing we need to do is setup some Terraform variables that we are going to be using.

Sensitive Variables
^^^^^^^^^^^^^^^^^^^
There are some variables throughout this setup that are sensitive and you don't want to store in your ``terraform.tfvars`` file, so for these you will do a ``export`` command to set the variables on your own shell.

As mentioned already in the previous step you will want to from your shell run ``export TF_VAR_token=XXX`` which is the Linode API token you already setup in the previous section.

This will be the only required variable that is a secret for the ``lke`` setup, when we setup the domain section next it will require more variables.

The other variables can be found in the ``lke/terraform.tfvars`` file.  These variables below control the cluster label and size of cluster, etc.

Other Variables
^^^^^^^^^^^^^^^
There are a few variables in the ``lke/terraform.tfvars`` file that need to be set in order to ensure your cluster is setup how you want.  This section will outline those variables.

Modify these for your needs.

1. The ``label`` controls what the cluster label will be named.
2. The ``k8s_version`` tells it what version of kubernetes to use.
3. The ``region`` tells what location to build the cluster in.
4. The ``pools`` is a list variable that tells what type of nodes to use and how many.  Currently it is setup to use shared nodes, All node types can be found `Here <https://api.linode.com/v4/linode/types>`_

.. note::
    Currently the pool setting defined configures the following:

    A shared 2GB Linode with 1 vcpu and costs about $10 per node per month for a total cost of $30, plus $10 a month for the load balancer.

Terraform Cloud Login For Remote State
--------------------------------------
Before peforming the next steps you will need to login via the cli to the terraform cloud and generate a token to use following the guide at https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login

Terraform Init & Plan
---------------------
Now that we have our variables all setup and should have Terraform installed now, we can initialize our project and run a plan to verify what it will do.

Make sure you are in the ``lke`` folder and run the following:

``terraform init`` - This will initialize everything needed for the project to run and install modules.

Once this is complete you can now run the plan command to validate you have all your vars setup and it can generate everything properly before applying it:

``terraform plan -var-file="terraform.tfvars"`` which will give a output of the information that it will deploy, validate this looks right before continuing.

Deploy LKE Terraform
--------------------
As long as we didn't have any issues with the previous Init & Plan step we can now deploy our cluster.

Ensuring we still have our ``TF_VAR_token`` exported on our shell then we can run:

``terraform apply -var-file="terraform.tfvars"`` which should ask for a yes prompt and then will deploy the cluster and will generate your kubeconfig to connect to it.

.. note::
    This step can take a few to complete since it has to spin up nodes and set it all up, so be patient.

Connecting To New Kubernetes Cluster
------------------------------------
After deploy we now need to generate our kubernetes config and tell kubectl to use it for connecting::


    export KUBE_VAR=`terraform output kubeconfig` && echo $KUBE_VAR | base64 -di > lke-cluster-config.yaml



Then we can run the following to tell kubectl to use it::


    export KUBECONFIG=$(pwd)/lke-cluster-config.yaml


If for some reason you ever delete your lke-cluster-config.yaml or lose it, you can regenerate it via::

    export KUBE_VAR=`terraform output kubeconfig` && echo $KUBE_VAR | base64 -di > lke-cluster-config.yaml
    export KUBECONFIG=$(pwd)/lke-cluster-config.yaml

This will recreate it and set the path of ``KUBECONFIG`` to it to be used.

Now we should be able to run ``kubectl cluster-info`` to get the info from the cluster which confirms we can access it::

   Kubernetes control plane is running at https://XXXX.us-east-2.linodelke.net:443
   KubeDNS is running at https://XXXX.us-east-2.linodelke.net:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

   To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'. 

Go ahead and run the following command to get the node_balancer external-ip address which you will need for the next dns steps::

    kubectl -n default get services -o wide ingress-ingress-nginx-controller


This should give us something like::

    NAME                          TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)                      AGE     SELECTOR
    my-ingress-nginx-controller   LoadBalancer   10.128.169.60   192.0.2.0   80:32401/TCP,443:30830/TCP   7h51m   app.kubernetes.io/instance=cingress-nginx,app.kubernetes.io/name=ingress-nginx

Let's move on to the ``dns`` folder and steps.