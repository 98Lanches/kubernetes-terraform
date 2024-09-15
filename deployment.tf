resource "kubernetes_deployment" "dotlanche_api_deployment" {
  depends_on = [
    kubernetes_secret.rds_secret  # Adiciona dependência do secret do RDS
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

          # Variáveis de ambiente com os secrets do RDS
          env {
            name = "ASPNETCORE_ENVIRONMENT"
            value = "Development"  # Ajuste conforme o ambiente
          }

          env {
            name = "ConnectionStrings__DefaultConnection"
            value_from {
              secret_key_ref {
                name = "rds-secrets"   # Nome do secret do RDS
                key  = "db_connection" # Adicione a chave de conexão completa, ou defina separadamente como abaixo
              }
            }
          }

          # Se quiser montar a string de conexão manualmente:
          env {
            name = "DB_USERNAME"
            value_from {
              secret_key_ref {
                name = "rds-secrets"
                key  = "db_username"
              }
            }
          }

          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "rds-secrets"
                key  = "db_password"
              }
            }
          }

          env {
            name = "DB_HOST"
            value_from {
              secret_key_ref {
                name = "rds-secrets"
                key  = "db_host"
              }
            }
          }

          env {
            name = "DB_NAME"
            value_from {
              secret_key_ref {
                name = "rds-secrets"
                key  = "db_name"
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
