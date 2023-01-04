data "openstack_networking_network_v2" "external-network" {
  name = "ext-net"
}

data "openstack_identity_auth_scope_v3" "scope" {
  name = "scope"
}

# https://github.com/rancher/terraform-provider-rancher2/issues/835
data "rancher2_cloud_credential" "rancher2_cloud_credential" {
  name = "${var.prefix}"
}

data "rancher2_project" "system" {
  name = "System"
  cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}"
}