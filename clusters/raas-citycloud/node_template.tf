
resource "rancher2_cloud_credential" "cred" {
  name = "${var.prefix}-cred"
  openstack_credential_config {
    password = var.os_password
  }
}

resource "rancher2_node_template" "citycloud" {
  name = "${lower(data.openstack_identity_auth_scope_v3.scope.project_name)}-${data.openstack_identity_auth_scope_v3.scope.region}-${var.node_flavor}"
  cloud_credential_id = rancher2_cloud_credential.cred.id
  openstack_config {
    availability_zone = ""
    auth_url = "https://${lower(data.openstack_identity_auth_scope_v3.scope.region)}.citycloud.com:5000/v3"
    region = data.openstack_identity_auth_scope_v3.scope.region
    username = data.openstack_identity_auth_scope_v3.scope.user_name
    // Do NOT use domain_name as it does not work with Openstack ATM
    domain_id = data.openstack_identity_auth_scope_v3.scope.project_domain_id
    // Do NOT use tenant_name as it does not work with Openstack ATM
    tenant_id = data.openstack_identity_auth_scope_v3.scope.project_id
    // Do NOT use net_name as it does not work with Openstack ATM
    net_id = openstack_networking_network_v2.custom_network.id
    endpoint_type = "publicURL"
    floating_ip_pool = data.openstack_networking_network_v2.external-network.name
    flavor_name = var.node_flavor
    image_name = var.vm_image
    ssh_user = var.vm_ssh_user
  }
}
