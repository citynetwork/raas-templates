
///////////////////////
// GENERAL
///////////////////////

variable "customer" {
  default = ""
}

// If needed, create a security group and rule in security_groups.tf
variable "customer_vpn" {
  default = ""
}

variable "prefix" {
  default = "custom"
}

variable "raas_domain" {
  default = "raas.citycloud.eu"
}

///////////////////////
// COMPUTE / CLUSTER
///////////////////////

variable "node_image" {
  default = "Ubuntu 18.04 Bionic Beaver"
}

variable "cidr" {
  default = "10.1.0.0/24"
}

// Master nodes

variable "n_of_master_nodes" {
  default = "3"
}

variable "flavor_master_nodes" {
  default = "2C-4GB-50GB"
}

variable "ssh_key_master_nodes" {
  default = "./.secrets/id_rsa_mc"
}

// Worker nodes

variable "n_of_worker_nodes" {
  default = "3"
}

variable "flavor_worker_nodes" {
  default = "4C-8GB-50GB"
}

variable "ssh_key_worker_nodes" {
  default = "./.secrets/id_rsa_wc"
}

///////////////////////
// NETWORKING
///////////////////////

// Create a Floating IP manually to avoid any mismatch between DNS <-> IP
variable "loadbalancer_ip" {
  default = ""

}

/*

///////////////////////
// SUBMARINER
///////////////////////

variable "vpnaas_psk" {
  default = ""
}

// Cluster A/B

variable "broker_router_public_ip" {
  default = ""
}

variable "broker_cidr" {
  default = ""
}

// Broker

variable "clusterA_router_public_ip" {
  default = ""
}

variable "clusterA_cidr" {
  default = ""
}

variable "clusterB_router_public_ip" {
  default = ""
}

variable "clusterB_cidr" {
  default = ""
}

*/