variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Região AWS onde a infraestrutura será criada."
}

variable "aws_profile" {
  type        = string
  default     = ""
  description = "Perfil AWS CLI opcional para uso local."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Nome do ambiente usado para tags e identificação."
}

variable "cluster_name" {
  type        = string
  default     = "projeto-dio-eks"
  description = "Nome do cluster EKS."
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR para a VPC."
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "CIDRs para as subnets públicas."
}

variable "private_subnets" {
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
  description = "CIDRs para as subnets privadas."
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  description = "Availability zones usadas para criar subnets e cluster."
}

variable "create_nat_gateway" {
  type        = bool
  default     = true
  description = "Se NAT Gateway deve ser criado para permitir acesso à internet a subnets privadas."
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Tipo da instância para o node group EKS e EC2 auxiliar."
}

variable "desired_capacity" {
  type        = number
  default     = 2
  description = "Quantidade desejada de nós gerenciados no node group EKS."
}

variable "min_capacity" {
  type        = number
  default     = 1
  description = "Quantidade mínima de nós no node group EKS."
}

variable "max_capacity" {
  type        = number
  default     = 3
  description = "Quantidade máxima de nós no node group EKS."
}

variable "enable_aux_ec2" {
  type        = bool
  default     = true
  description = "Se uma instância EC2 extra deve ser criada para operações de suporte."
}

variable "enable_codecommit" {
  type        = bool
  default     = false
  description = "Se deve ser criado um repositório AWS CodeCommit para espelhamento."
}

variable "codecommit_repo_name" {
  type        = string
  default     = "projeto-dio-repo"
  description = "Nome do repositório CodeCommit."
}

variable "ec2_key_name" {
  type        = string
  default     = ""
  description = "Par de chaves para acesso SSH à instância EC2 auxiliar, se desejado."
}
