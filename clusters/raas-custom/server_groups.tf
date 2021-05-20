resource "openstack_compute_servergroup_v2" "anti-affinity" {
  name = "${var.prefix}}-anti-affinity"
  policies = ["anti-affinity"]
}