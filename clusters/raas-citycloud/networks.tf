resource "openstack_networking_router_v2" "router" {
  name = "${var.prefix}-router"
  external_network_id = data.openstack_networking_network_v2.external-network.id
}

resource "openstack_networking_network_v2" "custom_network" {
  name = "${var.prefix}-network"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name = "${var.prefix}-subnet"
  network_id = openstack_networking_network_v2.custom_network.id
  cidr = var.cidr
}

resource "openstack_networking_router_interface_v2" "router-if" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

resource "openstack_compute_keypair_v2" "keypair" {
  name = var.vm_keypair_name
  public_key = file(pathexpand(var.ssh_public_key))
}