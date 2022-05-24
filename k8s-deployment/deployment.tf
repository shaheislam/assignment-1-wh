resource "kubernetes_namespace" "example_namespace" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = var.example_namespace
  }
}

resource "kubernetes_deployment" "example" {
  metadata {
    name      = "example-app"
    namespace = var.example_namespace
    labels = {
      app = "nginx-app"
    }
  }
  spec {
    replicas = 3
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = "25%"
        max_unavailable = "1"
      }
    }
    selector {
      match_labels = {
        app = "nginx-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx-app"
        }
      }
      spec {
        automount_service_account_token = true
        security_context {
          #Ensures container does not have root permissions
          run_as_group    = 100
          run_as_user     = 100
          run_as_non_root = true
        }
        service_account_name = kubernetes_service_account.example_app_sa.metadata[0].name
        container {
          #Unpriveleged container is a requirement to run the container as non-root
          image = "nginxinc/nginx-unprivileged:1.20"
          name  = "nginx-app"
          port {
            container_port = "27017"
          }
          env {
            name = "API_KEY"
            value_from {
              secret_key_ref {
                name = "example-app-secret"
                key  = "password"
              }
            }
          }
          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example_svc" {
  metadata {
    name      = "example-app"
    namespace = var.example_namespace
  }
  spec {
    selector = {
      app = "nginx-app"
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 27017
    }

    type = "NodePort"
  }
}

resource "kubernetes_service_account" "example_app_sa" {
  metadata {
    name      = "example-app-sa"
    namespace = var.example_namespace
  }
  secret {
    name = "${kubernetes_secret.example-app-secret.metadata.0.name}"
  }
}

resource "kubernetes_secret" "example-app-secret" {
  metadata {
    name      = "example-app-secret"
    namespace = var.example_namespace
    labels = {
      "sensitive" = "true"
      "app"       = "nginx-app"
    }
  }
  # 'data' will be automatically encoded into base64 before reaching the kubernetes API.
  data = {
    password = "P4ssw0rd"
  }
}

resource "kubernetes_pod_disruption_budget" "pdb" {
  metadata {
    name = "example-app-pdb"
  }
  spec {
    min_available = "2"
    selector {
      match_labels = {
        app = "nginx-app"
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "example-app-hpa" {
  metadata {
    name = "example-app-hpa"
  }

  spec {
    max_replicas = 10
    min_replicas = 2

    scale_target_ref {
      kind = "Deployment"
      name = "example-app"
    }
  }
}
