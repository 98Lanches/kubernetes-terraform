# Módulo para criar o cluster EKS na AWS.
# Ele provisiona o cluster e os recursos de rede necessários (subnets, VPC).
module "eks" {
  depends_on = [ module.vpc ]
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0" # Usamos uma versão estável do módulo EKS

  cluster_name    = "fiap_cluster_eks"         # Nome do cluster EKS
  cluster_version = "1.30"                     # Versão do Kubernetes que será usada
  vpc_id          = module.vpc.vpc_id          # ID da VPC criada anteriormente
  subnet_ids      = module.vpc.private_subnets # Usa as subnets privadas para os nós do EKS

  tags = {
    Name = "fiap-cluster-eks" # O nome da tag
    Environment = "development" # Identificador de ambiente
  }
}