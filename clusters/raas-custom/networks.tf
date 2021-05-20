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

// Master nodes

/* Only if Ingress with NodePort is needed

resource "openstack_compute_floatingip_v2" "fip_master" {
  count = var.n_of_master_nodes
  pool = data.openstack_networking_network_v2.external-network.name
}

resource "openstack_compute_floatingip_associate_v2" "fip_master_assoc" {
  count = var.n_of_master_nodes
  floating_ip = element(openstack_compute_floatingip_v2.fip_master.*.address, count.index)
  instance_id = element(openstack_compute_instance_v2.master.*.id, count.index)
}

*/

// Worker nodes

/* Only if Ingress with NodePort is needed

resource "openstack_compute_floatingip_v2" "fip_worker" {
  count = var.n_of_worker_nodes
  pool = data.openstack_networking_network_v2.external-network.name
}

resource "openstack_compute_floatingip_associate_v2" "fip_worker_assoc" {
  count = var.n_of_worker_nodes
  floating_ip = element(openstack_compute_floatingip_v2.fip_worker.*.address, count.index)
  instance_id = element(openstack_compute_instance_v2.worker.*.id, count.index)
}

*/
