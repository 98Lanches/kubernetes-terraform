
variable "eks_role" {
  description = "lab role to create eks cluster and node groups"
  type = string
}

# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "dotlanche_cluster"
  role_arn  = var.eks_role

  vpc_config {
    subnet_ids =  [
      aws_subnet.public_subnet_a.id,
      aws_subnet.public_subnet_b.id
    ]
    security_group_ids = [aws_security_group.basic_sg.id]
  }

  # Adicione tags se necessário
  tags = {
    Name = "dotlanche_cluster"
  }
}

# Node Group para o EKS
resource "aws_eks_node_group" "dotlanche_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "dotlanche_node_group"
  node_role_arn   = var.eks_role
  subnet_ids =  [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  # Adicione tags se necessário
  tags = {
    Name = "dotlanche_node_group"
  }
}
