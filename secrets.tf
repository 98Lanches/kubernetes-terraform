resource "aws_secretsmanager_secret" "dotlanche_db_secret" {
  name = "my-db-secret"
  
  tags = {
    Name = "my-db-secret"
  }
}

resource "aws_secretsmanager_secret_version" "dotlanche_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.dotlanche_db_secret.id
  secret_string = jsonencode({
    connection_string = "postgres://dotlancheuser:P@55w0rd@mydbendpoint:5432/dotlanches"
    db_password       = "P@55w0rd"
  })
}
