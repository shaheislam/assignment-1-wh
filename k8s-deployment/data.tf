data "template_file" "values" {
  template = file("${path.module}/files/values.yaml")
  vars = {
    container_registry = var.container_registry
  }
}
