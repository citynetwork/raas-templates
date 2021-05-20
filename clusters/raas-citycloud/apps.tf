/* Example!

resource "rancher2_cluster_sync" "active_cluster" {
  cluster_id =  rancher2_cluster.cluster.id
}

module "wordpress" {
  source = "./modules/wordpress"
  domain = var.caas_domain
  cluster = rancher2_cluster_sync.active_cluster
}

*/
