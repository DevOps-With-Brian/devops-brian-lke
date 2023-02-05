terraform {
  cloud {
    organization = "brianhh12301"

    workspaces {
      name = "linode-terraform-dns"
    }
  }
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.29.4"
    }
  }
}

provider "linode" {
  token = var.token
}

resource "linode_domain" "master_domain" {
    type = "master"
    domain = var.domain_name
    soa_email = var.soa_email
    tags = var.tags
}

resource "linode_domain_record" "rasa_dns_record" {
    domain_id = linode_domain.master_domain.id
    name = var.rasa_dns
    record_type = "A"
    target = var.nodebalancer_ip
}

resource "linode_domain_record" "github_pages" {
    domain_id = linode_domain.master_domain.id
    count = length(var.github_pages_ips)
    name = var.domain_name
    record_type = "A"
    target = var.github_pages_ips[count.index]
}

resource "linode_domain_record" "github_cname" {
    domain_id = linode_domain.master_domain.id
    name = "www"
    record_type = "CNAME"
    target = var.github_pages_alias
}