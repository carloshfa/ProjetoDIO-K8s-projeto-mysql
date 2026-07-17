# Projeto DIO Kubernetes / MySQL

Este repositório contém uma aplicação completa composta por frontend, backend PHP, banco de dados MySQL, orquestração Kubernetes e infraestrutura AWS com Terraform.

## Sumário

- [Visão geral do projeto](#visão-geral-do-projeto)
- [Estrutura do repositório](#estrutura-do-repositório)
- [Componentes principais](#componentes-principais)
  - [Frontend](#frontend)
  - [Backend](#backend)
  - [Database](#database)
  - [Kubernetes](#kubernetes)
  - [CI/CD e segurança](#cicd-e-segurança)
  - [Infraestrutura AWS](#infraestrutura-aws)
- [Requisitos](#requisitos)
- [Como executar localmente com Docker](#como-executar-localmente-com-docker)
- [Como aplicar no Kubernetes](#como-aplicar-no-kubernetes)
- [Como usar Terraform](#como-usar-terraform)
- [Versionamento e branches](#versionamento-e-branches)
- [Segurança e SAST](#segurança-e-sast)
- [Observações importantes](#observações-importantes)
- [Próximos passos](#próximos-passos)

## Visão geral do projeto

A solução cobre:

- Frontend web estático em HTML/CSS/JS
- Backend PHP com Apache que grava mensagens no MySQL
- Banco de dados MySQL inicializado via script SQL
- Dockerfiles para frontend, backend e database
- Manifests Kubernetes para backend e banco de dados
- GitHub Actions para validação e análise de segurança
- Terraform para provisionamento de infraestrutura AWS

## Estrutura do repositório

```text
backend/         # backend PHP e Dockerfile
frontend/        # frontend HTML/CSS/JS e Dockerfile
database/        # Dockerfile do MySQL e script SQL
scripts/         # scripts de build, push e teste
terraform/       # infraestrutura AWS via Terraform
deployment.yml   # deployment Kubernetes para MySQL e backend
services.yml     # serviços Kubernetes para MySQL e backend
.github/         # workflow GitHub Actions
README.md        # documentação unificada do projeto
```

## Componentes principais

### Frontend
- `frontend/index.html`
- `frontend/js.js`
- `frontend/css.css`

O formulário envia os dados via AJAX ao backend. Atualmente o frontend é considerado fora do cluster e deve apontar para o backend exposto.

### Backend
- `backend/index.php`
- `backend/conexao.php`
- `backend/Dockerfile`

O backend recebe `POST` com `nome`, `email` e `comentario` e insere na tabela `mensagens` do MySQL.

### Database
- `database/Dockerfile`
- `database/sql.sql`

O MySQL 5.7 é inicializado com uma tabela simples `mensagens`.

### Kubernetes
- `deployment.yml`
- `services.yml`

O Kubernetes provisiona:
- PersistentVolume e PersistentVolumeClaim para MySQL
- Deployment MySQL
- Deployment Backend com initContainer que aguarda MySQL
- Service ClusterIP para MySQL
- Service LoadBalancer para Backend

### CI/CD e segurança
- `.github/workflows/ci.yml`
- `scripts/test.sh`
- `scripts/build-images.sh`
- `scripts/push-images.sh`
- `scripts/build-and-push.sh`

O workflow é acionado manualmente (`workflow_dispatch`) e inclui validação de scripts e manifests. Também adicionamos o Checkov para análise de segurança como etapa informativa, sem bloquear o deploy.

### Infraestrutura AWS
- `terraform/`

A infraestrutura Terraform provisiona recursos AWS agnósticos para o projeto:
- VPC com subnets públicas e privadas
- Internet Gateway e NAT Gateway
- Cluster EKS e node group
- Load Balancer Application
- Instância EC2 auxiliar para suporte
- Repositório CodeCommit opcional

## Requisitos

Antes de executar o projeto, instale:

- Docker
- Kubernetes (Docker Desktop com Kubernetes ou outro cluster)
- Git
- Terraform 1.5+
- AWS CLI configurado para o ambiente AWS

## Como executar localmente com Docker

1. Construir as imagens:

```bash
bash scripts/build-images.sh seu-usuario-dockerhub latest
```

2. (Opcional) Fazer push:

```bash
bash scripts/push-images.sh seu-usuario-dockerhub latest
```

3. Para build + push em uma etapa:

```bash
bash scripts/build-and-push.sh seu-usuario-dockerhub latest
```

## Uso dos scripts

O repositório inclui scripts de automação em `scripts/` para build, push e validação.

- `scripts/build-images.sh <REPO_PREFIX> [TAG]`
  - Constrói imagens Docker para `backend`, `frontend` e `database`.
  - `REPO_PREFIX`: prefixo do repositório Docker (ex: `seu-usuario-dockerhub`).
  - `TAG`: tag da imagem (default `latest`).
  - Exemplo:

    ```bash
    bash scripts/build-images.sh seu-usuario-dockerhub latest
    ```

- `scripts/push-images.sh <REPO_PREFIX> [TAG]`
  - Faz login no Docker Hub e envia as imagens.
  - `REPO_PREFIX`: prefixo usado no build.
  - `TAG`: tag da imagem (default `latest`).
  - Requer `DOCKERHUB_USERNAME` se não passar `REPO_PREFIX`.
  - Para login não interativo, defina `DOCKERHUB_PASSWORD`.
  - Exemplo:

    ```bash
    export DOCKERHUB_USERNAME=seu-usuario-dockerhub
    export DOCKERHUB_PASSWORD=sua-senha
    bash scripts/push-images.sh seu-usuario-dockerhub latest
    ```

- `scripts/build-and-push.sh <REPO_PREFIX> [TAG]`
  - Executa `build-images.sh` e `push-images.sh` em sequência.
  - Exemplo:

    ```bash
    bash scripts/build-and-push.sh seu-usuario-dockerhub latest
    ```

- `scripts/test.sh`
  - Valida a sintaxe dos scripts shell.
  - Verifica se os Dockerfiles e os manifests Kubernetes existem.
  - Exemplo:

    ```bash
    bash scripts/test.sh
    ```

- `scripts/test.ps1`
  - Versão PowerShell da validação de `test.sh`.
  - Execute no Windows com PowerShell:

    ```powershell
    powershell -ExecutionPolicy Bypass -File scripts/test.ps1
    ```

### Observações importantes

- Ajuste `REPO_PREFIX` para usar seu usuário ou organização Docker.
- Se usar outra registry, atualize os nomes de imagem em `deployment.yml`.
- Use Git Bash ou PowerShell no Windows para executar os scripts shell.

## Como aplicar no Kubernetes

  - `TAG`: tag da imagem (default `latest`).
  - Exemplo:

    ```bash
    bash scripts/build-images.sh seu-usuario-dockerhub latest
    ```

- `scripts/push-images.sh <REPO_PREFIX> <TAG>`
  - Envia as imagens para o Docker Hub.
  - Requer `DOCKERHUB_USERNAME` ou `REPO_PREFIX`.
  - Suporta `DOCKERHUB_PASSWORD` para login não interativo.
  - Exemplo:

    ```bash
    bash scripts/push-images.sh seu-usuario-dockerhub latest
    ```

- `scripts/build-and-push.sh <REPO_PREFIX> <TAG>`
  - Executa `build-images.sh` e `push-images.sh` em sequência.
  - Exemplo:

    ```bash
    bash scripts/build-and-push.sh seu-usuario-dockerhub latest
    ```

- `scripts/test.sh`
  - Valida a sintaxe dos scripts shell.
  - Verifica a existência dos Dockerfiles e dos manifests Kubernetes.
  - Exemplo:

    ```bash
    bash scripts/test.sh
    ```

- `scripts/test.ps1`
  - Versão PowerShell da validação de `test.sh`.
  - Execute no Windows com PowerShell:

    ```powershell
    powershell -ExecutionPolicy Bypass -File scripts/test.ps1
    ```

## Como aplicar no Kubernetes

1. Substitua `YOUR_DOCKERHUB_USERNAME` em `deployment.yml` pelos seus nomes de imagem.
2. Aplique os manifests:

```bash
kubectl apply -f deployment.yml
kubectl apply -f services.yml
```

3. Verifique o status do cluster:

```bash
kubectl get pods --all-namespaces
kubectl get svc --all-namespaces
kubectl describe pod <nome-do-pod>
```

4. Acesse o backend pelo IP/hostname do LoadBalancer exposto:

```bash
kubectl get svc backend
```

## Como usar Terraform

### Exemplo de shell para iniciar o Terraform

```bash
cd terraform
terraform init
terraform validate
terraform plan -var='aws_region=us-east-1' -var='environment=dev'
```

### Aplicar infraestrutura

```bash
terraform apply -var='aws_region=us-east-1' -var='environment=dev'
```

### Atualizar infra depois de mudanças

```bash
terraform plan -var='aws_region=us-east-1' -var='environment=dev'
terraform apply -var='aws_region=us-east-1' -var='environment=dev'
```

### Destruir ambiente

```bash
terraform destroy -var='aws_region=us-east-1' -var='environment=dev'
```

5. Para criar o repositório CodeCommit:

O diretório `terraform/` contém a infraestrutura AWS necessária.

1. Entre no diretório Terraform:

```bash
cd terraform
```

2. Inicialize o Terraform:

```bash
terraform init
```

3. Planeje a infraestrutura:

```bash
terraform plan -var='aws_region=us-east-1' -var='environment=dev'
```

4. Aplique o ambiente:

```bash
terraform apply -var='aws_region=us-east-1' -var='environment=dev'
```

5. Para criar o repositório CodeCommit:

```bash
terraform apply -var='enable_codecommit=true' -var='codecommit_repo_name=projeto-dio-repo'
```

## Versionamento e branches

Recomenda-se usar um fluxo de branches para desenvolvimento e deploy:

- `main` para produção ou código estável
- `terraform` para mudanças de infraestrutura
- `feature/*` para novas funcionalidades e correções
- `security/*` para ajustes de segurança e análise

Sempre mantenha o `README.md` atualizado com as mudanças de arquitetura, pipeline e infra.

## Segurança e SAST

Atualmente o projeto inclui:

- `Checkov` para análise de IaC no workflow GitHub Actions

Futuras adições recomendadas:

- `Semgrep` para PHP/JS
- `hadolint` para Dockerfile
- `OWASP ZAP` ou `Nuclei` para DAST
- `Gitleaks` para busca de segredos

## Observações importantes

- O frontend foi projetado para funcionar fora do cluster.
- O backend espera o MySQL acessível via `mysql` no cluster Kubernetes.
- As credenciais do MySQL padrão usadas no manifesto são `root / Senha123` e banco `meubanco`.
- Ajuste ConfigMaps, Secrets e Ingress conforme o ambiente de produção.

## Próximos passos

Você pode evoluir o projeto com:

- frontend implantado dentro do cluster Kubernetes
- Ingress e TLS
- Secrets gerenciados com AWS Secrets Manager ou Kubernetes Secrets
- backend com autenticação/validação e proteção contra injeção SQL
- pipeline CI/CD completo com deploy automático
