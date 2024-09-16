# Grupo de sub-redes para o banco de dados
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "dotlanche-db-subnet-group"
  subnet_ids         = [
      aws_subnet.public_subnet_a.id,
      aws_subnet.public_subnet_b.id
    ]

  tags = {
    Name = "dotlanche-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "custom_postgres" {
  name        = "custom-postgres16"
  family      = "postgres16"
  description = "Custom parameter group for PostgreSQL 16"
}

# Instância RDS
resource "aws_db_instance" "dotlanche_db" {
  identifier              = "fiap-rds"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = "dotlancheuser"
  password                = "cP8KZps3mn02dsOi"
  db_name                 = "dotlanches"
  parameter_group_name    = aws_db_parameter_group.custom_postgres.name
  vpc_security_group_ids  = [aws_security_group.basic_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  multi_az                = false
  publicly_accessible     = false

  tags = {
    Name = "dotlanche-db-instance"
  }
}

output "rds_endpoint" {
  value = aws_db_instance.dotlanche_db.endpoint
}