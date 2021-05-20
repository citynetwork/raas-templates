
resource "openstack_identity_ec2_credential_v3" "ec2_creds" {
  // By setting it empty, is uses the current project scope
}

resource "openstack_objectstorage_container_v1" "cluster_etcd_backup" {
  name = "${var.prefix}-cluster-etcd-backup"
}