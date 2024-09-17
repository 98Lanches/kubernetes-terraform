# kubernetes-terraform
Infraestrutura com Kubernetes e Terraform

## Como rodar esse projeto
Necessario que possui as seguintes ferramentas instaladas
 - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
 - [Kubectl](https://kubernetes.io/pt-br/docs/tasks/tools/)
 - [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)

### Agora devemos seguir o passo-a-passo
1. Gerar uma chave ssh, esse [tutorial](https://docs.github.com/pt/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) mostra como fazer 
2. Adicionar a chave ssh dentro do AWS CLI com o seguinte comando `aws ec2 import-key-pair --key-name "<nome-da-chave>" --public-key-material file://<caminho-da-chave>.pub`
    - Caso ocorra o seguinte erro `Invalid base64: XXXXXX`, é necessario realizar esse workaround `aws ec2 import-key-pair --key-name "<nome-da-chave>" --public-key-material fileb://<caminho-da-chave>`, nesse workaround é utilizado o fileb que utilizado o binario como chave
3. Dentro do projeto rodar o comando `terraform init`
4. Rodar o comando `terraform plan` para executar as verificações
5. Rodar o comando `terraform apply` para aplicar as alterações