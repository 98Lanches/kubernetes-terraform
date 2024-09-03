resource "kubernetes_service" "dotlanche_db_svc" {
  depends_on = [kubernetes_stateful_set.dotlanche_db]
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
  depends_on = [
    kubernetes_deployment.dotlanche_api_deployment
  ]
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

