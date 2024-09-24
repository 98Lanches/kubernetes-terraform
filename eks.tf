resource "aws_eks_cluster" "dotcluster" {
  name     = "dotcluster"
  role_arn = var.eks_role

  vpc_config {
    subnet_ids = [
      aws_subnet.private-us-east-1a.id,
      aws_subnet.private-us-east-1b.id,
      aws_subnet.public-us-east-1a.id,
      aws_subnet.public-us-east-1b.id
    ]

    security_group_ids = [aws_security_group.eks_security_group.id]
  }
}

resource "aws_eks_node_group" "dotcluster-nodes" {
  cluster_name    = aws_eks_cluster.dotcluster.name
  node_group_name = "dotcluster-nodes"
  node_role_arn   = var.eks_role

  subnet_ids = [
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.micro"]

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    node = "kubenode02"
  }
}
