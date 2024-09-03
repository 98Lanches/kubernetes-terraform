resource "kubernetes_horizontal_pod_autoscaler_v2" "dotlanche_api_hpa" {
  depends_on = [ kubernetes_service.dotlanche_api_svc ]
  metadata {
    name = "dotlanche-api-hpa"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "dotlanche-api-deployment"
    }

    min_replicas = 3
    max_replicas = 7

    metric {
      type = "Resource"

      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 30
        }
      }
    }
  }
}
