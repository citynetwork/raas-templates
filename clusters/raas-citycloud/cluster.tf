resource "rancher2_cluster_v2" "cluster" {
  name = var.prefix
  kubernetes_version = "v1.24.8+rke2r1"
  enable_network_policy = false
  default_cluster_role_for_project_members = "user"
  rke_config {
    machine_pools {
      name = "master"
      cloud_credential_secret_name = data.rancher2_cloud_credential.rancher2_cloud_credential.id
      control_plane_role = true
      etcd_role = true
      worker_role = false
      quantity = var.no_master_nodes
      machine_config {
        kind = rancher2_machine_config_v2.openstack.kind
        name = rancher2_machine_config_v2.openstack.name
      }
    }
    machine_pools {
      name = "worker"
      cloud_credential_secret_name = data.rancher2_cloud_credential.rancher2_cloud_credential.id
      control_plane_role = false
      etcd_role = false
      worker_role = true
      quantity = var.no_worker_nodes
      machine_config {
        kind = rancher2_machine_config_v2.openstack.kind
        name = rancher2_machine_config_v2.openstack.name
      }
    }
    machine_selector_config {
      config = {
        disable = "rke2-ingress-nginx"
      }
    }
}
  lifecycle {
    ignore_changes = [
      cloud_credential_secret_name,
    ]
  }
  depends_on = [
    openstack_networking_subnet_v2.subnet,
    rancher2_cloud_credential.cloud_credential_name,
  ]
}

resource "rancher2_cluster_sync" "cluster" {
  cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}"
  depends_on = [
    rancher2_cluster_v2.cluster,
  ]
}

resource "local_sensitive_file" "kube_config" {
  filename = "kubeconfig.yml"
  content = rancher2_cluster_v2.cluster.kube_config
}
