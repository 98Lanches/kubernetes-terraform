# Role IAM para os nós do EKS. Ela define permissões para que os nós
# possam interagir com outros serviços da AWS (por exemplo, EBS para armazenamento).
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role" # Nome da Role

  # Política que permite que o serviço EC2 assuma a role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com" # Permite que EC2 use essa role
        }
      }
    ]
  })
}

# Anexa políticas necessárias à role dos nós, permitindo que eles
# usem serviços como EKS, redes e ECR (Container Registry).
resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::426655075367:role/LabRole" # Política que permite aos nós interagir com o EKS
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::426655075367:role/LabRole" # Política para gerenciar redes dentro do cluster Kubernetes
}

resource "aws_iam_role_policy_attachment" "eks_registry_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::426655075367:role/LabRole" # Permite que os nós puxem imagens de container do ECR
}
