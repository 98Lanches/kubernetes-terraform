# Grupo de sub-redes para o banco de dados
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids         = [
      aws_subnet.public_subnet_a.id,
      aws_subnet.public_subnet_b.id
    ]

  tags = {
    Name = "my-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "custom_postgres" {
  name        = "custom-postgres16"
  family      = "postgres16"
  description = "Custom parameter group for PostgreSQL 16"
}

# Instância RDS
resource "aws_db_instance" "my_db" {
  identifier              = "fiap-rds"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = "mydbuser"
  password                = "cP8KZps3mn02dsOi"
  db_name                 = "dotlanches"
  parameter_group_name    = aws_db_parameter_group.custom_postgres.name
  vpc_security_group_ids  = ["sg-0fba150b4ded6eec4"]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  multi_az                = false
  publicly_accessible     = false

  tags = {
    Name = "my-db-instance"
  }
}

output "rds_endpoint" {
  value = aws_db_instance.my_db.endpoint
}