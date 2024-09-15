# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-cluster"
  role_arn  = "arn:aws:iam::426655075367:role/LabRole"

  vpc_config {
    subnet_ids =  [
      aws_subnet.public_subnet_a.id,
      aws_subnet.public_subnet_b.id
    ]
    security_group_ids = ["sg-0fba150b4ded6eec4"]
  }

  # Adicione tags se necessário
  tags = {
    Name = "my-cluster"
  }
}

# Node Group para o EKS
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = "arn:aws:iam::426655075367:role/LabRole"
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
    Name = "my-node-group"
  }
}
