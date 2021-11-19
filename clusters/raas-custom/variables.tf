
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

// ObjectStorage (S3, Swift) is currently available only in Kna1, Fra1, Tky1, Dx1
variable "cluster_backup_region" {
  default = ""
}

// The container MUST be created manually in the target region as follows:
//   $ openstack container create <cluster_backup_container>
variable "cluster_backup_container" {
  default = ""
}

variable "cluster_backup_access" {
  default = ""
}

variable "cluster_backup_secret" {
  default = ""
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

// Create the Floating IP manually to avoid any mismatch between DNS <> LoadBalancer PublicIP
//  $ openstack floating ip create ext-net
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