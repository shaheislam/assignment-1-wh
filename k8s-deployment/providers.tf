terraform {
  required_version = "~> 0.13"
  required_providers {
    mycloud = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
  backend "local" {
    path = "/tmp/terraform.tfstate"
  }
}

provider "kubernetes" {
  host = "https://127.0.0.1:${var.minikube_port}"
}

provider "helm" {
  kubernetes {
    host = "https://127.0.0.1:${var.minikube_port}"
  }
}
