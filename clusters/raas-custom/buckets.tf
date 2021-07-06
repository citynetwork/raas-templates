
// NOTE: ObjectStorage (S3, Swift) is available only in Kna1, Fra1, Tky1, Dx1

resource "openstack_identity_ec2_credential_v3" "ec2_creds" {

  // NOTE: By setting the resource empty, the current project scope is used

  // If ObjectStorage from another region is required, fill in the below variable:
  // region = ""
  // access = ""
  // secret = ""
  // project = ""

}

resource "openstack_objectstorage_container_v1" "cluster_etcd_backup" {
  name = "${var.prefix}-cluster-etcd-backup"
}