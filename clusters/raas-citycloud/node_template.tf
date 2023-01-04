
resource "rancher2_cloud_credential" "cloud_credential_name" {
  name = "${var.prefix}"
  openstack_credential_config {
    password = var.os_password
  }
}

resource "rancher2_machine_config_v2" "openstack" {
  generate_name = "openstack"
  openstack_config {
    availability_zone = "nova"
    auth_url = "https://${lower(data.openstack_identity_auth_scope_v3.scope.region)}.citycloud.com:5000/v3/"
    region = data.openstack_identity_auth_scope_v3.scope.region
    username = data.openstack_identity_auth_scope_v3.scope.user_name
    domain_id = data.openstack_identity_auth_scope_v3.scope.project_domain_id
    endpoint_type = "publicURL"
    flavor_name = var.node_flavor
    image_name = var.vm_image
    keypair_name = var.vm_keypair_name
    private_key_file = "${var.ssh_private_key}"
    net_id = openstack_networking_network_v2.custom_network.id
    password = var.os_password
    ssh_user = var.vm_ssh_user
    tenant_id = data.openstack_identity_auth_scope_v3.scope.project_id
  }
  lifecycle {
    ignore_changes = [
      openstack_config.0.volume_size,
    ]
  }
}
