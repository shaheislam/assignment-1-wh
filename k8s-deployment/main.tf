# resource "helm_release" "metrics_server" {
#   name        = "metrics-server"
#   chart       = "${path.module}/charts/metrics-server"
#   namespace   = "kube-system"
#   values      = [data.template_file.values.rendered]
#   max_history = 5
#   postrender {
#     binary_path = "${path.module}/kustomize/kustomize.sh"
#   }
# }
