terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
    local = {
      source  = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
    rancher2 = {
      source = "rancher/rancher2"
    }
  }
  required_version = ">= 0.13"
}
