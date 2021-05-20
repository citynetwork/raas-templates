data "openstack_networking_network_v2" "external-network" {
  name = "ext-net"
}

data "openstack_identity_auth_scope_v3" "scope" {
  name = "scope"
}

data "template_file" "master_user_data" {
  template = file("./config/cloud-config.yml")
  vars = {
    username = var.customer
    custom_ssh = openstack_compute_keypair_v2.master.public_key
    registration_command = "${rancher2_cluster.custom.cluster_registration_token[0]["node_command"]} --etcd --controlplane"
  }
  depends_on = [rancher2_cluster.custom]
}

data "template_file" "worker_user_data" {
  template = file("./config/cloud-config.yml")
  vars = {
    username = var.customer
    custom_ssh = openstack_compute_keypair_v2.worker.public_key
    registration_command = "${rancher2_cluster.custom.cluster_registration_token[0]["node_command"]} --worker"
  }
  depends_on = [rancher2_cluster.custom]
}
