
resource "local_file" "kube_config" {
  filename = "./gen_files/kubeconfig.yml"
  sensitive_content = rancher2_cluster.custom.kube_config
}
