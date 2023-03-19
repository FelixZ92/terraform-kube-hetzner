provider "hcloud" {
  token = var.hcloud_token
}

terraform {
  required_version = ">= 1.3.3"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.35.2"
    }
  }
}
