data "openstack_networking_network_v2" "external-network" {
  name = "ext-net"
}

data "openstack_identity_auth_scope_v3" "scope" {
  name = "scope"
}