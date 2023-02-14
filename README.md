# devops-brian-lke
[![version](https://img.shields.io/badge/version-0.0.1-blue)](https://github.com/btotharye/devops-brian-lke/blob/main/CHANGELOG.md)

If using custom dns and setting up a domain then you will want on your domain registrar/current dns for it update it to use custom nameservers:

```
ns1.linode.com
ns2.linode.com
ns3.linode.com
ns4.linode.com
ns5.linode.com
```

This will then allow linode to control the dns, I am doing that in this repo since this hosts all my stuff under my domain and I want to have ssl setup on my kubernetes apps.

## How To Use
This repo consists of a few folders that setup different things in linode.  The `lke` folder is for setting up kubernetes and after that is setup the `dns` folder can be used to setup the linode domain/dns config for the ingress.  Each folder has a README with instructions on what to do.

The general steps is to go to the `lke` folder first and follow the instructions to setup the kubernetes cluster and ingress.

After that go to the `dns` folder and set that up if you want a custom domain and public dns options for getting to your public apps off kubernetes.

Finally you go to the `cert-manager` folder to setup the cert manager for Let's Encrypt ssl certs setup and encrypting your public pods.

The `rasa` dir is an example helm setup with a values file for deploying our Rasa chatbot onto the cluster and being able to talk to it over SSL.

The full documentation and setup can be found below by building out the docs locally or you can visit the generated docs for the cookiecutter located [Here](https://cookiecutter-linode-tf-lke.readthedocs.io/)

# Docs
Docs are setup with [Sphinx ReadtheDocs](https://docs.readthedocs.io/en/latest/intro/getting-started-with-sphinx.html) and pushed to https://cookiecutter-linode-tf-lke.readthedocs.io/.

Ensure you have python3 installed, you can find instructions [Here](https://www.python.org/downloads/) on how to install python.

I recommend building out the docs locally and working off them since they will be catered to the information you provided in the cookiecutter setup.

In order to build docs locally setup a new python virtualenv and install the requirements:

```
python3 -m venv .venv
source .venv/bin/activate
pip install -r docs/requirements.txt
```

Then you can run `make html` from the `docs` dir to build the docs which will then be located in the `docs/_build` dir.

Then open the `docs/_build/index.html` in a web browser.
