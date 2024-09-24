resource "aws_vpc" "dotlanches-vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "dotlanches-vpc"
  }
}

resource "aws_internet_gateway" "dotlanches-vpc-igw" {
  vpc_id = aws_vpc.dotlanches-vpc.id

  tags = {
    Name = "dotlanches-vpc-igw"
  }
}

# PRIVATE SUBNETS
resource "aws_subnet" "private-us-east-1a" {
  vpc_id            = aws_vpc.dotlanches-vpc.id
  cidr_block        = "192.168.0.0/19"
  availability_zone = "us-east-1a"

  tags = {
    Name                              = "private-us-east-1a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
    type                              = "private"
  }
}

resource "aws_subnet" "private-us-east-1b" {
  vpc_id            = aws_vpc.dotlanches-vpc.id
  cidr_block        = "192.168.32.0/19"
  availability_zone = "us-east-1b"

  tags = {
    Name                              = "private-us-east-1b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
    type                              = "private"
  }
}

# PUBLIC SUBNETS

resource "aws_subnet" "public-us-east-1a" {
  vpc_id                  = aws_vpc.dotlanches-vpc.id
  cidr_block              = "192.168.64.0/19"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                         = "public-us-east-1a"
    "kubernetes.io/role/elb"     = "1" #this instruct the kubernetes to create public load balancer in these subnets
    "kubernetes.io/cluster/demo" = "owned"
    type                         = "public"
  }
}

resource "aws_subnet" "public-us-east-1b" {
  vpc_id                  = aws_vpc.dotlanches-vpc.id
  cidr_block              = "192.168.96.0/19"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                         = "public-us-east-1b"
    "kubernetes.io/role/elb"     = "1" #this instruct the kubernetes to create public load balancer in these subnets
    "kubernetes.io/cluster/demo" = "owned"
    type                         = "public"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "k8s-nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-us-east-1a.id

  tags = {
    Name = "k8s-nat"
  }

  depends_on = [aws_internet_gateway.dotlanches-vpc-igw]
}

# ROUTE TABLES
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.dotlanches-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.k8s-nat.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dotlanches-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dotlanches-vpc-igw.id
  }

  tags = {
    Name = "public"
  }
}


# ROUTING TABLE ASSOCIATIONS

resource "aws_route_table_association" "private-us-east-1a" {
  subnet_id      = aws_subnet.private-us-east-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-us-east-1b" {
  subnet_id      = aws_subnet.private-us-east-1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-us-east-1a" {
  subnet_id      = aws_subnet.public-us-east-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-us-east-1b" {
  subnet_id      = aws_subnet.public-us-east-1b.id
  route_table_id = aws_route_table.public.id
}
