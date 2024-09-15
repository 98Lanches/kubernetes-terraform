resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-fiap-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "rds-fiap-subnet-group"
  }
}

resource "aws_db_instance" "rds_instance_fiap" {
  identifier        = "rds-fiap-instance"   # Identificador do recurso RDS
  engine            = "postgres"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = "mydb"              # Nome do banco de dados criado no RDS
  username          = "fiap"             # Nome do usuário
  password          = "mysecretpassword"  # Senha
  parameter_group_name = "default.postgres12"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot  = true
  publicly_accessible  = false

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "rds-fiap-instance"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-fiap-security-group"
  description = "Allow access to RDS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432 # Porta padrão do PostgreSQL
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Alterar para uma rede mais segura
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
