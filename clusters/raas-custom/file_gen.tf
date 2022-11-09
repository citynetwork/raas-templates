
resource "local_sensitive_file" "kube_config" {
  filename = "./gen_files/kubeconfig.yml"
  content = rancher2_cluster.custom.kube_config
}
