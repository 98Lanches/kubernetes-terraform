provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_pod" "dotlanche_db" {
  metadata {
    name = "dotlanche-db"
    labels = {
      app = "dotlanche-db"
    }
  }

  spec {
    container {
      name    = "c-dotlanche-db"
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
    }
  }
}


resource "kubernetes_service" "dotlanche_db_svc" {
  metadata {
    name = "dotlanche-db-svc"
    labels = {
      app = "dotlanche-db-svc"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = "dotlanche-db"
    }

    port {
      port        = 5432
      target_port = 5432
    }
  }
}

resource "kubernetes_deployment" "dotlanche_api_deployment" {
  metadata {
    name = "dotlanche-api-deployment"
    labels = {
      app = "dotlanche"
    }
  }

  spec {
    replicas = 1

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
          name  = "c-dotlanche-api"
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

resource "kubernetes_service" "dotlanche_api_svc" {
  metadata {
    name = "dotlanche-api-svc"
  }

  spec {
    type = "NodePort"

    selector = {
      app = "dotlanche-api"
    }

    port {
      port        = 80
      target_port = 8080
      node_port   = 30000
    }
  }
}

resource "kubernetes_secret" "dotlanche_secrets" {
  metadata {
    name = "dotlanche-secrets"
  }

  data = {
    connection-string = base64encode("Host=dotlanche-db-svc;Port=5432;Database=dotlanches;Username=admin;Password=P@55w0rd")
    db-password       = base64encode("P@55w0rd")
  }

  type = "Opaque"
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "dotlanche_api_hpa" {
  metadata {
    name = "dotlanche-api-hpa"
  }

  spec {
    min_replicas = 3
    max_replicas = 7

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "dotlanche-api-deployment"
    }

    metric {
      type = "Resource"

      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 30
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume" "dotlanche_pv" {
  metadata {
    name = "dotlanche-persistent-volume"
    labels = {
      app = "dotlanche-pv"
    }
  }

  spec {
    capacity = {
      storage = "500Mi"
    }

    access_modes = ["ReadWriteOnce"]

    storage_class_name = "local-storage"

    persistent_volume_reclaim_policy = "Retain"

    persistent_volume_source {
      host_path {
        path = "C:/Users/André/repos/dotlanche/.volumeMount"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "dotlanche_pvc" {
  metadata {
    name = "dotlanche-persistent-volume-claim"
    labels = {
      app = "dotlanche-pvc"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "450Mi"
      }
    }
  }
}
