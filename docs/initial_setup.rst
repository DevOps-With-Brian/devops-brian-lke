**************
Initial Setup
**************
This documentation section goes over the initial setup of everything required to setup a `Linode <https://www.linode.com/lp/refer/?r=24202434814cd6f94325c26c8a78803a931bed0f>`_ LKE cluster as code via `Terraform <https://www.terraform.io/>`_.  This currently sets up the following after complete::

 Linode LKE - Kubernetes Cluster with 3 shared nodes
 Linode node_balancer - Using nginx ingress it will use this to allow for public resources if wanted from kubernetes.
 Linode Domain - Custom domain in linode to be used for dns resolution in kubernetes as well as for a githubpages if desired.

This also sets up cert-manager in kubernetes and allows for auto cert generation using Let's Encrypt using annocations on our deployments.

There are a few prerequisites if you decide to use this whole project.  The following sections go over some of those and how to set them up. 

Commitizen & Conventional Commits
---------------------------------
This repo uses `Conventional Commits <https://www.conventionalcommits.org/en/v1.0.0/>`_ along with `Commitizen <https://commitizen-tools.github.io/commitizen/>`_ to allow for auto versioning and such.

Ensure you are using conventional commits for your commit messages and ensure you have installed Commitizen as well from the link provided above.

Custom Domain
-------------
For the entire project the way I am using it you will need your own domain, otherwise you can skip the ingress ssl and domain parts and only use the LKE Terraform.

Once you setup your own domain you are going to want to point it to the Linode nameservers:

.. parsed-literal::

    ns1.linode.com
    ns2.linode.com
    ns3.linode.com
    ns4.linode.com
    ns5.linode.com


Terraform
---------
You will also want to ensure you have `Terraform Downloads <https://developer.hashicorp.com/terraform/downloads>`_ installed.

Also this repo uses remote state located in Terraform Cloud, more information can be found at https://www.hashicorp.com/products/terraform/pricing.
Currently using the Free tier and setup an account for free.  After setting up a free account you will want to generate an API token as discussed in https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login.


Linode Account
--------------
You will also want to sign up for a `Linode <https://www.linode.com/lp/refer/?r=24202434814cd6f94325c26c8a78803a931bed0f>`_ account if you don't already have one.

This setup if used completely will setup as previously stated above the LKE, Node_Balancer, and Domain setup in Linode.

For more information on Terraform on Linode for LKE please see `Deploy LKE Cluster Using Terraform <https://www.linode.com/docs/guides/how-to-deploy-an-lke-cluster-using-terraform/>`_ 

GitHub Pages
------------
If you want to use the `GitHub Pages <https://pages.github.com/>`_ you will want to setup a repo for that, I recommend using `Minimal Mistakes Starter <https://github.com/mmistakes/mm-github-pages-starter/generate>`_ clicking that link will create a new repo based off their template.

Just follow the instructions for setting up the GitHub pages on the previously mentioned link.

Kubectl Install
---------------
You will also want to have Kubectl Installed, they have installers for `Linux <https://kubernetes.io/docs/tasks/tools/install-kubectl-linux>`_, `Windows <https://kubernetes.io/docs/tasks/tools/install-kubectl-windows>`_, and `macOS <https://kubernetes.io/docs/tasks/tools/install-kubectl-macos>`_
