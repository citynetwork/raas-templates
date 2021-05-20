
resource "rancher2_cluster" "cluster" {
  name = var.prefix
  rke_config {
    network {
      plugin = "canal"
    }

    cloud_provider {
      openstack_cloud_provider {
        global {
          auth_url = "https://${lower(data.openstack_identity_auth_scope_v3.scope.region)}.citycloud.com:5000/v3/"
          password = var.os_password
          username = data.openstack_identity_auth_scope_v3.scope.user_name
          domain_id = data.openstack_identity_auth_scope_v3.scope.project_domain_id
          tenant_id = data.openstack_identity_auth_scope_v3.scope.project_id
        }
        block_storage {
          ignore_volume_az = true
          trust_device_path = false
        }
        metadata {
          request_timeout = 0
        }
        load_balancer {
          subnet_id = openstack_networking_subnet_v2.subnet.id
          floating_network_id = data.openstack_networking_network_v2.external-network.id
          use_octavia = true
        }
      }
    }
  }
}

resource "rancher2_node_pool" "node_pool" {
  cluster_id = rancher2_cluster.cluster.id
  name = var.prefix
  hostname_prefix = var.prefix
  node_template_id = rancher2_node_template.citycloud.id
  quantity = 3
  control_plane = true
  etcd = true
  worker = true
}
