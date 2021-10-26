
///////////////////////
// ENVIRONMENT VARs
///////////////////////

variable "os_password" { type = string }

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
  default = "2C-4GB-50GB"
}

variable "cidr" {
  default = "10.1.0.0/24"
}

variable "vm_image" {
  default = "Ubuntu 18.04 Bionic Beaver"
}

variable "vm_ssh_user" {
  default = "ubuntu"
}

// supported docker version can be found at https://github.com/rancher/install-docker
variable "docker_version" {
  default = "20.10"
  description = "The docker version to install on all nodes"
}
