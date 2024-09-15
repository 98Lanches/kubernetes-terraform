resource "kubernetes_secret" "rds_secret" {
  metadata {
    name = "rds-secret"
  }

  data = {
    username = base64encode("admin")
    password = base64encode("mysecretpassword")
    host     = base64encode(aws_db_instance.rds_instance_fiap.endpoint)
    dbname   = base64encode("mydb")
  }
}
