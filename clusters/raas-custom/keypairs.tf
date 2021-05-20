resource "openstack_compute_keypair_v2" "master" {
  name = "${var.prefix}-master"
  public_key = file(pathexpand("${var.ssh_key_master_nodes}.pub"))
}

resource "openstack_compute_keypair_v2" "worker" {
  name = "${var.prefix}-worker"
  public_key = file(pathexpand("${var.ssh_key_worker_nodes}.pub"))
}
