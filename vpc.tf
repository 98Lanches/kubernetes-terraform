resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Criar uma Subnet Pública em us-east-1a
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block               = "10.0.3.0/24"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = true
  tags = {
    Name = "public-subnet-a"
  }
}

# Criar uma Subnet Pública em us-east-1b
resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block               = "10.0.4.0/24"
  availability_zone        = "us-east-1b"
  map_public_ip_on_launch  = true
  tags = {
    Name = "public-subnet-b"
  }
}

# Criar um Gateway de Internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-gateway"
  }
}

# Criar uma Tabela de Rotas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associar a Subnet Pública a Tabela de Rotas
resource "aws_route_table_association" "public_subnet_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public.id
}
