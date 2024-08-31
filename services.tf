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

resource "kubernetes_service" "dotlanche_api_svc" {
  metadata {
    name = "dotlanche-api-svc"
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "dotlanche-api"
    }

    port {
      port        = 80
      target_port = 8080
    }
  }
}
