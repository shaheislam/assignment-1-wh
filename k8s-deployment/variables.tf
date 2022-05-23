# variable "cluster_name" {
#   description = "Name of EKS cluster"
#   type        = string
# }

# variable "account_name" {
#   description = "NBS AWS Spoke Account Name"
#   type        = string
# }

variable "example_namespace" {
  description = "Namespace to deploy our application into"
  type        = string
  default     = "example-app"
}

# variable "region" {
#   type    = string
#   default = "eu-west-2"
# }

# variable "role_arn" {
#   type = string
# }
