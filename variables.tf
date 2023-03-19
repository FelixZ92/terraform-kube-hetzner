variable "hcloud_token" {
  sensitive = true
  default   = ""
}

# do not change
variable "cluster_ipv4_cidr" {
  default = "10.42.0.0/16"
}

# do not change
variable "network_ipv4_cidr" {
  default = "10.0.0.0/8"
}

variable "ssh_public_key" {
  default = ""
}
variable "ssh_private_key" {
  default = ""
}
