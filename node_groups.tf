# Recurso para criar um grupo de nós (Node Group) no EKS.
# Esses são os servidores EC2 que vão rodar os containers do Kubernetes.
resource "aws_eks_node_group" "default" {
  cluster_name    = module.eks.cluster_name        # Nome do cluster ao qual o Node Group estará associado
  node_group_name = "default"                      # Nome do Node Group
  node_role_arn   = aws_iam_role.eks_node_role.arn # Role IAM que os nós usarão para permissões
  subnet_ids      = module.vpc.private_subnets     # Usa subnets privadas para maior segurança

  # Configurações de escalabilidade do Node Group
  scaling_config {
    desired_size = 2 # Número de nós desejados (EC2 instances)
    max_size     = 3 # Número máximo de nós
    min_size     = 1 # Número mínimo de nós
  }

  instance_types = ["t2.micro"] # Tipo de instância EC2 usada para os nós (equilíbrio entre custo e performance)

  depends_on = [
    module.eks # Assegura que o cluster EKS esteja criado antes dos nós
  ]
}
