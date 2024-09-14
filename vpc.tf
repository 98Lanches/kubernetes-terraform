# Módulo para criar uma VPC (Virtual Private Cloud)
# com subnets públicas e privadas. Isso é necessário para hospedar o cluster EKS.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 3.18.0"

  name    = "fiap-eks-vpc"              # Nome da VPC
  cidr    = "10.0.0.0/16"          # Bloco CIDR da VPC

  azs             = ["us-east-1a", "us-east-1b"] # Zonas de disponibilidade para distribuir os recursos
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"] # Subnets públicas em cada AZ
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"] # Subnets privadas em cada AZ

  enable_nat_gateway = true  # Ativa o NAT Gateway para permitir que instâncias privadas acessem a internet
  single_nat_gateway = true  # Usa apenas um NAT Gateway para economia de custos

  tags = {
    Name = "fiap-eks-vpc"              # Tags para identificar a VPC
  }
}
