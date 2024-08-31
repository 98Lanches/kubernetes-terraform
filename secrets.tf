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
