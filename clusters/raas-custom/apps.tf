/* Example!

resource "rancher2_cluster_sync" "active_cluster" {
  cluster_id =  rancher2_cluster.custom_cluster.id
  depends_on = [openstack_compute_instance_v2.worker_nodes, openstack_compute_instance_v2.master_nodes]
}

module "wordpress" {
  source = "./modules/wordpress"
  domain = var.caas_domain
  cluster = rancher2_cluster_sync.active_cluster
}

*/
