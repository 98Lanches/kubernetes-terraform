resource "kubernetes_stateful_set" "dotlanche_db" {
  metadata {
    name = "dotlanche-db"
    labels = {
      app = "dotlanche-db"
    }
  }

  spec {
    service_name = "dotlanche-db-svc"
    replicas     = 1

    selector {
      match_labels = {
        app = "dotlanche-db"
      }
    }

    template {
      metadata {
        labels = {
          app = "dotlanche-db"
        }
      }

      spec {
        container {
          name    = "postgres"
          image   = "postgres:16.3-alpine3.18"
          command = ["docker-entrypoint.sh"]
          args    = ["-c", "max_connections=500"]

          port {
            container_port = 5432
          }

          env {
            name  = "POSTGRES_DB"
            value = "dotlanches"
          }

          env {
            name  = "POSTGRES_USER"
            value = "admin"
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = "dotlanche-secrets"
                key  = "db-password"
              }
            }
          }

          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }

          liveness_probe {
            exec {
              command = ["pg_isready", "-U", "admin", "-d", "dotlanches"]
            }
            initial_delay_seconds = 30
            period_seconds        = 30
          }

          readiness_probe {
            exec {
              command = ["pg_isready", "-U", "admin", "-d", "dotlanches"]
            }
            initial_delay_seconds = 15
            period_seconds        = 10
          }
        }

        volume {
          name = "postgres-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.dotlanche_pvc.metadata[0].name
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "postgres-storage"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "500Mi"
          }
        }
      }
    }
  }
}
