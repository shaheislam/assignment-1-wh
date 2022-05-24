variable "example_namespace" {
  description = "Namespace to deploy our application into"
  type        = string
  default     = "example-app"
}

variable "minikube_port" {
  description = "Port to access Minikube cluster"
  type        = string
  default     = "52692"
}
