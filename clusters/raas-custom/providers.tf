provider "rancher2" {
  api_url = "https://${var.raas_domain}"
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
}

provider "openstack" {
  use_octavia = true
}