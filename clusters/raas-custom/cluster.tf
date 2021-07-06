
resource "rancher2_cluster" "custom" {
  name = "${var.customer}-${var.prefix}"
  cluster_auth_endpoint {
    enabled = true
  }
  rke_config {
    # kubernetes_version =
    network {
      plugin = "canal"
    }
    services {
      // NOTE: ObjectStorage (S3, Swift) is available only in Kna1, Fra1, Tky1, Dx1
      etcd {
        backup_config {
          s3_backup_config {
            bucket_name = openstack_objectstorage_container_v1.cluster_etcd_backup.name
            endpoint = "s3-${lower(data.openstack_identity_auth_scope_v3.scope.region)}.citycloud.com:8080"
            access_key = openstack_identity_ec2_credential_v3.ec2_creds.access
            secret_key = openstack_identity_ec2_credential_v3.ec2_creds.secret
          }
        }
      }
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
  lifecycle {
    ignore_changes = [cluster_monitoring_input]
  }
}