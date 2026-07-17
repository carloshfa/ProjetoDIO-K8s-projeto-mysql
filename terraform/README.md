# Terraform Infrastructure

Este diretório contém a infraestrutura necessária para provisionar a aplicação no AWS usando Terraform.

## Componentes provisionados

- VPC com subnets públicas e privadas
- Internet Gateway e NAT Gateway
- EKS cluster e node group
- Instância EC2 auxiliar para operações de suporte
- Application Load Balancer para expor o ambiente
- AWS CodeCommit opcional para espelhar o código GitHub

## Uso

1. Instale o Terraform 1.5+.
2. Entre no diretório Terraform:

```bash
cd terraform
```

3. Inicialize o Terraform:

```bash
terraform init
```

4. Ajuste as variáveis em `terraform.tfvars` ou passe via CLI:

```bash
terraform plan -var='aws_region=us-east-1' -var='environment=dev'
```

5. Aplique a infraestrutura:

```bash
terraform apply -var='aws_region=us-east-1' -var='environment=dev'
```

6. Para criar o repositório CodeCommit opcional:

```bash
terraform apply -var='enable_codecommit=true' -var='codecommit_repo_name=projeto-dio-repo'
```

## Configurações recomendadas

- Use `aws_profile` se estiver usando múltiplas credenciais AWS.
- Defina `ec2_key_name` para acessar a instância EC2 via SSH, se necessário.
- Ajuste `instance_type`, `desired_capacity` e `max_capacity` conforme o ambiente.

## Observações

- A infraestrutura está projetada para ser reutilizada em diferentes ambientes por meio de variáveis.
- A criação de CodeCommit é opcional e controlada por `enable_codecommit`.
- O load balancer é configurado para tráfego HTTP na porta 80.
