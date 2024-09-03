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
        storage = "500Mi"
      }
    }
  }
}
