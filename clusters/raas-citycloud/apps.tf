resource "rancher2_catalog_v2" "cloud-provider-openstack" {
  cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}"
  name = "cloud-provider-openstack"
  url = "https://kubernetes.github.io/cloud-provider-openstack"
  depends_on = [
    rancher2_cluster_sync.cluster,
  ]
}
resource "rancher2_catalog_v2" "ingress-nginx" {
  cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}"
  name = "ingress-nginx"
  url = "https://kubernetes.github.io/ingress-nginx"
  depends_on = [
    rancher2_cluster_sync.cluster,
  ]
}

resource "rancher2_catalog_v2" "jetstack" {
  cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}"
  name = "jetstack"
  url = "https://charts.jetstack.io"
  depends_on = [
    rancher2_cluster_sync.cluster,
  ]
}

resource "rancher2_app_v2" "cert-manager" {
  cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}"
  name = "cert-manager"
  namespace = "cert-manager"
  repo_name = "jetstack"
  chart_name = "cert-manager"
  values = file("${path.module}/config/cert_manager-values.yaml")
  depends_on = [
    rancher2_catalog_v2.jetstack,
  ]
}

resource "rancher2_app_v2" "openstack-cloud-controller-manager" {
  cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}"
  name = "openstack-cloud-controller-manager"
  namespace = "kube-system"
  repo_name = "cloud-provider-openstack"
  chart_name = "openstack-cloud-controller-manager"
  values = templatefile("${path.module}/templates/openstack-ccm_values.tftpl", { floating_network_id = (data.openstack_networking_network_v2.external-network.id), subnet_id = openstack_networking_subnet_v2.subnet.id, endpoint = "https://${lower(data.openstack_identity_auth_scope_v3.scope.region)}.citycloud.com:5000", username = (data.openstack_identity_auth_scope_v3.scope.user_name), password = var.os_password, tenant_name = (data.openstack_identity_auth_scope_v3.scope.project_name), domain_name = (data.openstack_identity_auth_scope_v3.scope.user_domain_name), region = (data.openstack_identity_auth_scope_v3.scope.region), router_id = "${openstack_networking_router_v2.router.id}", cluster_name = rancher2_cluster_v2.cluster.name })
  # For some reason, that I can't really find, the cloud-provider-openstack helm chart does not create the neccesary roles and rolebindings.
  # So, solving it like this for now.
  provisioner "local-exec" {
    command = <<-EOT
      kubectl --kubeconfig kubeconfig.yml apply -f https://raw.githubusercontent.com/kubernetes/cloud-provider-openstack/master/manifests/controller-manager/cloud-controller-manager-roles.yaml
      kubectl --kubeconfig kubeconfig.yml apply -f https://raw.githubusercontent.com/kubernetes/cloud-provider-openstack/master/manifests/controller-manager/cloud-controller-manager-role-bindings.yaml
    EOT
  }
  depends_on = [
    rancher2_catalog_v2.cloud-provider-openstack,
    local_sensitive_file.kube_config,
  ]
}

resource "rancher2_app_v2" "openstack-cinder-csi" {
  cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}"
  name = "openstack-cinder-csi"
  namespace = "kube-system"
  repo_name = "cloud-provider-openstack"
  chart_name = "openstack-cinder-csi"
  values = templatefile("${path.module}/templates/csi-values.tftpl", { endpoint = "https://${lower(data.openstack_identity_auth_scope_v3.scope.region)}.citycloud.com:5000/v3/", username = (data.openstack_identity_auth_scope_v3.scope.user_name), password = var.os_password, tenant_name = (data.openstack_identity_auth_scope_v3.scope.project_name), domain_name = (data.openstack_identity_auth_scope_v3.scope.user_domain_name), subnet_name = openstack_networking_subnet_v2.subnet.name, cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}" })
  depends_on = [
    rancher2_catalog_v2.cloud-provider-openstack,
  ]
  # Terraform wants to apply changes to the chart values.yaml on every apply, so ignoring any changes pending a proper fix.
  lifecycle {
    ignore_changes = [
      values,
    ]
  }
}

resource "rancher2_app_v2" "rancher-monitoring" {
  cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}"
  name = "rancher-monitoring"
  namespace = "cattle-monitoring-system"
  repo_name = "rancher-charts"
  chart_name = "rancher-monitoring"
  values = file("./config/rancher-monitoring_values.yaml")
  depends_on = [
    rancher2_cluster_sync.cluster,
  ]
}

resource "rancher2_app_v2" "ingress-nginx" {
  cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}"
  name = "ingress-nginx"
  namespace = "ingress-nginx"
  repo_name = "ingress-nginx"
  chart_name = "ingress-nginx"
  values = file("./config/ingress-nginx_values.yaml")
  depends_on = [
    rancher2_catalog_v2.ingress-nginx,
    rancher2_app_v2.openstack-cloud-controller-manager,
  ]
}

resource "rancher2_secret_v2" "rancher-backup-secret" {
  cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}"
  name = "s3-credentials"
  namespace = "cattle-resources-system"
  data = {
      accessKey = var.s3_access_key
      secretKey = var.s3_secret_key
  }
  depends_on = [
    rancher2_cluster_sync.cluster,
  ]
}

resource "rancher2_app_v2" "rancher-backup" {
  cluster_id = "${rancher2_cluster_v2.cluster.cluster_v1_id}"
  name = "rancher-backup"
  namespace = "cattle-resources-system"
  repo_name = "rancher-charts"
  chart_name = "rancher-backup"
  values = templatefile("${path.module}/templates/rancher-backup_values.tftpl", { region = (data.openstack_identity_auth_scope_v3.scope.region), bucket_name = var.prefix, s3_endpoint = var.s3_endpoint,  })
  provisioner "local-exec" {
    command = <<-EOT
      kubectl --kubeconfig kubeconfig.yml apply -f ./config/rancher-backup_midnight.yaml
    EOT
  }
  depends_on = [
    rancher2_cluster_sync.cluster,
  ]
}