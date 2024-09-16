resource "null_resource" "update_rds_secret" {
  depends_on = [aws_db_instance.dotlanche_db]

  provisioner "local-exec" {
    command = <<EOT
      # Retrieve the RDS endpoint
      endpoint=$(aws rds describe-db-instances --db-instance-identifier fiap-rds --query 'DBInstances[0].Endpoint.Address' --output text)
      
      # Update the secret with the new endpoint
      aws secretsmanager put-secret-value --secret-id dotlanche-db-secret --secret-string '{"connection_string": "postgres://dotlancheuser:P@55w0rd@'"$endpoint"':5432/dotlanches", "db_password": "P@55w0rd"}'
    EOT

    environment = {
      AWS_PROFILE = "default"
    }
  }
}