terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Provider para o Kubernetes usando as informações do cluster EKS
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint  # Endpoint do API do cluster EKS
  token                  = data.aws_eks_cluster_auth.eks.token  # Token de autenticação para o cluster
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)  # Certificado da CA do cluster
}

# Data source para obter o token de autenticação do cluster EKS
data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name  # Nome do cluster EKS
  depends_on = [ resource.aws_eks_node_group.default ]
}