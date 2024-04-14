terraform {
  cloud {
    organization = "brianhh12301"

    workspaces {
      name = "devops-brian-lke"
    }
  }
  required_providers {
     local = {
      version = "~> 2.1"
    }
    linode = {
      source  = "linode/linode"
      version = "2.19.0"
    }
  }
}

provider "linode" {
  token = var.token
}

resource "linode_lke_cluster" "linode_lke" {
    label       = var.label
    k8s_version = var.k8s_version
    region      = var.region
    tags        = var.tags

    dynamic "pool" {
        for_each = var.pools
        content {
            type  = pool.value["type"]
            count = pool.value["count"]
        }
    }
}

provider "helm" {
  kubernetes {
    host                   = yamldecode(base64decode(linode_lke_cluster.linode_lke.kubeconfig)).clusters[0].cluster.server
    token                  = yamldecode(base64decode(linode_lke_cluster.linode_lke.kubeconfig)).users[0].user.token
    cluster_ca_certificate = base64decode(yamldecode(base64decode(linode_lke_cluster.linode_lke.kubeconfig)).clusters[0].cluster.certificate-authority-data)
  }
}

provider "kubernetes" {
  host                   = yamldecode(base64decode(linode_lke_cluster.linode_lke.kubeconfig)).clusters[0].cluster.server
  token                  = yamldecode(base64decode(linode_lke_cluster.linode_lke.kubeconfig)).users[0].user.token
  cluster_ca_certificate = base64decode(yamldecode(base64decode(linode_lke_cluster.linode_lke.kubeconfig)).clusters[0].cluster.certificate-authority-data)
}

resource "kubernetes_namespace" "cert_manager" {
  depends_on   = [linode_lke_cluster.linode_lke]
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "ingress-nginx" {
  depends_on   = [linode_lke_cluster.linode_lke]
  name       = "ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
}
