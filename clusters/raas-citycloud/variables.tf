
///////////////////////
// ENVIRONMENT VARs
///////////////////////
variable "os_password" { type = string }
variable "os_tenant_name" { type = string }
variable "os_user_domain_name" { type = string }
variable "s3_access_key" { type = string }
variable "s3_secret_key" { type = string }

variable "rancher_access_key" { type = string }
variable "rancher_secret_key" { type = string }

///////////////////////
// CUSTOM VARs
///////////////////////

variable "prefix" {
  default = "citycloud"
}

variable "raas_domain" {
  default = "raas.citycloud.eu"
}

variable "node_flavor" {
  default = "4C-8GB-50GB"
}

variable "cidr" {
  default = "10.1.0.0/24"
}

variable "vm_image" {
  default = "Ubuntu 22.04 Jammy Jellyfish 20220810"
}

variable "vm_ssh_user" {
  default = "ubuntu"
}

variable "vm_keypair_name" {
  default = "citycloud"
}

variable "ssh_private_key" {
  default = "./.secrets/id_ed25519"
}

variable "ssh_public_key" {
  default = "./.secrets/id_ed25519.pub"
}

variable "no_master_nodes" {
  default = "3"
}

variable "no_worker_nodes" {
  default = "3"
}

///////////////////////
// RANCHER BACKUP
///////////////////////
variable "s3_endpoint" {
  default = "s3endpoint"
}