# Kubernetes Project - App Base

Este projeto monta uma aplicação simples com frontend, backend e banco de dados MySQL, usando Docker e Kubernetes para containerização e orquestração.

## Visão geral

A aplicação é composta por:

- Frontend: interface web em HTML/CSS/JS
- Backend: aplicação PHP que recebe os dados do formulário
- Banco de dados: MySQL com inicialização via script SQL

A estrutura do projeto é:

```text
backend/         # aplicação PHP
frontend/        # arquivos do frontend
database/        # Dockerfile e script SQL do MySQL
scripts/         # scripts de build, push e teste
deployment.yml   # deployments e PVC do Kubernetes
services.yml     # serviços do Kubernetes
```

## Requisitos

Antes de usar este projeto, certifique-se de ter instalado:

- Docker
- Kubernetes (ou um cluster local como Docker Desktop com Kubernetes habilitado)
- Git

## Estrutura de containers

### Backend
O backend utiliza a imagem oficial do PHP com Apache e expõe a porta 80.

### Frontend
O frontend utiliza Nginx e expõe a porta 80.

### Banco de dados
O banco usa a imagem oficial do MySQL 5.7 com um script SQL para inicializar o schema.

## Como construir as imagens Docker

Na raiz do projeto, execute:

```bash
bash scripts/build-images.sh seu-usuario-dockerhub latest
```

Esse comando cria as imagens:

- seu-usuario-dockerhub/backend:latest
- seu-usuario-dockerhub/frontend:latest
- seu-usuario-dockerhub/database:latest

## Como publicar no Docker Hub

```bash
bash scripts/push-images.sh seu-usuario-dockerhub latest
```

Antes de publicar, faça login no Docker Hub:

```bash
docker login
```

## Fluxo completo de build e push

Para executar build + push em uma única etapa:

```bash
bash scripts/build-and-push.sh seu-usuario-dockerhub latest
```

## Testes automáticos

O projeto inclui uma etapa de validação simples para checar scripts, Dockerfiles e manifests do Kubernetes.

Execute:

```bash
bash scripts/test.sh
```

Ou, no PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\test.ps1
```

## Kubernetes

Os arquivos de configuração do Kubernetes são:

- deployment.yml
- services.yml

Eles definem:

- um PersistentVolume local para o banco MySQL, usando hostPath em /tmp/mysql-data
- um PersistentVolumeClaim para o banco MySQL
- um deployment para o MySQL
- um deployment para o backend
- serviços para expor o MySQL e o backend

### Aplicar no cluster

```bash
kubectl apply -f deployment.yml
kubectl apply -f services.yml
```

## Observações importantes

- Substitua `YOUR_DOCKERHUB_USERNAME` nos manifests por seu nome de usuário real do Docker Hub.
- O backend espera acessar o banco pelo nome `mysql` dentro do cluster.
- O MySQL usa as credenciais configuradas no manifesto para criar o banco `meubanco`.

## Próximos passos

Você pode evoluir este projeto adicionando:

- frontend no Kubernetes
- ConfigMaps e Secrets para credenciais
- ingress para expor a aplicação externamente
- pipeline CI/CD com GitHub Actions para build e deploy automáticos
