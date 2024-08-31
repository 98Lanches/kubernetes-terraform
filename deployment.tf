resource "kubernetes_deployment" "dotlanche_api_deployment" {
  depends_on = [
    kubernetes_secret.dotlanche_secrets,
    kubernetes_service.dotlanche_db_svc
  ]
  metadata {
    name = "dotlanche-api-deployment"
    labels = {
      app = "dotlanche"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "dotlanche-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "dotlanche-api"
        }
      }

      spec {
        container {
          name  = "container-dotlanche-api"
          image = "atcorrea/dotlanche-api:1.2"

          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "200Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "500Mi"
            }
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 5
            failure_threshold     = 2
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 10
            period_seconds        = 30
            failure_threshold     = 3
          }

          env {
            name  = "ASPNETCORE_ENVIRONMENT"
            value = "Development"
          }

          env {
            name = "ConnectionStrings__DefaultConnection"
            value_from {
              secret_key_ref {
                name = "dotlanche-secrets"
                key  = "connection-string"
              }
            }
          }

          env {
            name  = "RunMigrationsOnStartup"
            value = "true"
          }
        }
      }
    }
  }
}
