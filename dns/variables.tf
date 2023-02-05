variable "token" {
    description = "Your Linode API Personal Access Token. (required)"
}

variable "nodebalancer_ip" {
    description = "The nodebalancer public ip address to use for dns records."
}

variable "domain_name" {
    description = "The domain name to create/modify"
}

variable "soa_email" {
    description = "The start of authority email address."
}

variable "rasa_dns" {
    description = "The subdomain name to use for rasa_dns record"
    default = "rasa"
}

variable "tags" {
    description = "Tags to apply to domain"
    type = list(string)
    default = ["prod"]
}

variable "linode_nameservers" {
    description = "The linode nameservers"
    default     = [
        "ns1.linode.com",
        "ns2.linode.com",
        "ns3.linode.com",
        "ns4.linode.com",
        "ns5.linode.com"
    ] 
}

variable "github_pages_alias" {
    description = "The github pages address for your page."
}

variable "github_pages_ips" {
    description = "The github pages ip's"
    default     =   [
        "185.199.108.153",
        "185.199.109.153",
        "185.199.110.153",
        "185.199.111.153"
    ]
}