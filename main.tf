module "kube-hetzner" {
  providers = {
    hcloud = hcloud
  }
  hcloud_token = var.hcloud_token

  source = "kube-hetzner/kube-hetzner/hcloud"

  ssh_public_key  = local.ssh_public_key
  ssh_private_key = local.ssh_private_key

  control_plane_nodepools = [
    {
      name        = "control-plane-fsn1",
      server_type = "cpx11",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 1
    },
    {
      name        = "control-plane-nbg1",
      server_type = "cpx11",
      location    = "nbg1",
      labels      = [],
      taints      = [],
      count       = 1
    },
    {
      name        = "control-plane-hel1",
      server_type = "cpx11",
      location    = "hel1",
      labels      = [],
      taints      = [],
      count       = 1
    }
  ]

  agent_nodepools = [
    {
      name        = "agent-small",
      server_type = "cpx11",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 1
    },
    {
      name        = "agent-large",
      server_type = "cpx21",
      location    = "nbg1",
      labels      = [],
      taints      = [],
      count       = 1
    },
  ]

  control_planes_custom_config = {
    etcd-expose-metrics = true
  }

  load_balancer_location = "nbg1"
  base_domain            = "mycluster.example.com"

  # autoscaler_nodepools = [
  #   {
  #     name        = "autoscaled-small"
  #     server_type = "cpx21" # must be same or better than the control_plane server type (regarding disk size)!
  #     location    = "fsn1"
  #     min_nodes   = 0
  #     max_nodes   = 5
  #   }
  # ]

  # traefik_additional_options = []

  cluster_name = "staging"

  extra_firewall_rules = [
    {
      description     = "To Allow ArgoCD access to resources via SSH"
      direction       = "out"
      protocol        = "tcp"
      port            = "22"
      source_ips      = [] # Won't be used for this rule
      destination_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      description = "Allow Incoming Requests to Hubble Server & Hubble Relay (Cilium)"
      direction   = "in"
      protocol    = "tcp"
      port        = "4244-4245"
      source_ips  = [var.network_ipv4_cidr]
      destination_ips = []
    }
  ]
  cni_plugin    = "cilium"
  cilium_values = templatefile("deployments/cilium.yaml", {
    cluster_ipv4_cidr : var.cluster_ipv4_cidr
  })
  use_control_plane_lb = true
  # extra_kustomize_parameters={}
  create_kubeconfig    = false
  # create_kustomization = false
}
