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
