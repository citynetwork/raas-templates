
resource "openstack_compute_instance_v2" "master" {
  count = var.n_of_master_nodes
  name = "${var.prefix}-master-${count.index+1}"
  image_name = var.node_image
  flavor_name = var.flavor_master_nodes
  key_pair = openstack_compute_keypair_v2.master.name
  security_groups = [
    openstack_networking_secgroup_v2.citynetwork.name,
    openstack_networking_secgroup_v2.rancher.name
  ]
  user_data = templatefile("./config/cloud-config.yml", { custom_ssh = var.ssh_key_master_nodes, username = var.default_user, registration_command = "${rancher2_cluster.custom.cluster_registration_token[0]["node_command"]} --etcd --controlplane" })
  config_drive = "true"
  power_state = "active"
  scheduler_hints {
    group = openstack_compute_servergroup_v2.anti-affinity.id
  }
  network {
    uuid = openstack_networking_network_v2.custom_network.id
  }
  lifecycle {
    ignore_changes = [user_data]
  }
}

resource "openstack_compute_instance_v2" "worker" {
  count = var.n_of_worker_nodes
  name = "${var.prefix}-worker-${count.index+1}"
  image_name = var.node_image
  flavor_name = var.flavor_worker_nodes
  key_pair = openstack_compute_keypair_v2.worker.name
  security_groups = [
    openstack_networking_secgroup_v2.citynetwork.name,
    openstack_networking_secgroup_v2.rancher.name
  ]
  user_data = templatefile("./config/cloud-config.yml", { custom_ssh = openstack_compute_keypair_v2.worker.name, username = var.default_user, registration_command = "${rancher2_cluster.custom.cluster_registration_token[0]["node_command"]} --worker" })
  config_drive = "true"
  power_state = "active"
  scheduler_hints {
    group = openstack_compute_servergroup_v2.anti-affinity.id
  }
  network {
    uuid = openstack_networking_network_v2.custom_network.id
  }
  lifecycle {
    ignore_changes = [user_data]
  }
  depends_on = [openstack_compute_instance_v2.master]
}