resource "kubernetes_service" "dotlanche_api_service" {
  metadata {
    name = "dotlanche-api-service"
    labels = {
      app = "dotlanche-api"
    }
  }

  spec {
    selector = {
      app = "dotlanche-api"
    }

    port {
      port        = 80
      target_port = 8080
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}
