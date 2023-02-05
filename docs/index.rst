.. DevOps With Brian - Linode Terraform documentation master file, created by
   sphinx-quickstart on Sat Nov 19 05:49:22 2022.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to Linode LKE Terraform documentation!
================================================================
This documentation goes over the initial setup of everything required to setup a `Linode <https://www.linode.com/lp/refer/?r=24202434814cd6f94325c26c8a78803a931bed0f>`_ LKE cluster as code via `Terraform <https://www.terraform.io/>`_.  This currently sets up the following after complete:

| Linode LKE - Kubernetes Cluster with 3 shared nodes
| Linode node_balancer - Using nginx ingress it will use this to allow for public resources if wanted from kubernetes.
| Linode Domain - Sets up your own domain in linode to be used for dns resolution in kubernetes as well as for a githubpages if desired.

This also sets up cert-manager in kubernetes and allows for auto cert generation using Let's Encrypt using annocations on our deployments.



.. Hidden TOCs

.. toctree::
   :maxdepth: 3
   :caption: Documentation
   :hidden:

   initial_setup
   kubernetes_setup
   dns_domain_setup
   cert_manager_setup
   rasa_demo_setup
   destroying_resources

.. toctree::
   :maxdepth: 1
   :caption: Changelog
   :hidden:

   changelog
