locals {
  ssh_public_key = var.ssh_public_key != "" ? var.ssh_public_key : file("~/.ssh/id_ed25519.pub")
  ssh_private_key = var.ssh_private_key != "" ? var.ssh_private_key : file("~/.ssh/id_ed25519")
}
