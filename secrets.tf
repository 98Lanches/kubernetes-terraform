resource "kubernetes_secret" "dotlanche_secrets" {
  metadata {
    name = "dotlanche-secrets"
  }

  data = {
    connection-string = "Host=dotlanche-db-svc;Port=5432;Database=dotlanches;Username=admin;Password=P@55w0rd"
    db-password       = "P@55w0rd"
  }

  type = "Opaque"
}
