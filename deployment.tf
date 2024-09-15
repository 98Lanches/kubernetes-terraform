resource "kubernetes_deployment" "dotlanche_api_deployment" {
  depends_on = [
    aws_secretsmanager_secret_version.my_db_secret_version,
    null_resource.update_rds_secret
  ]

  metadata {
    name = "dotlanche-api-deployment"
    labels = {
      app = "dotlanche-api"
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
          image = "atcorrea/dotlanche-api:1.4"

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
            name = "DB_CONNECTION_STRING"
            value_from {
              secret_key_ref {
                name = "my-db-secret" # Nome do Kubernetes Secret gerado pelo ExternalSecret
                key  = "connection-string"
              }
            }
          }

          env {
            name  = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "my-db-secret" # Nome do Kubernetes Secret gerado pelo ExternalSecret
                key  = "db-password"
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
