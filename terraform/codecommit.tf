resource "aws_codecommit_repository" "repo" {
  count           = var.enable_codecommit ? 1 : 0
  repository_name = var.codecommit_repo_name
  description     = "Repositório AWS CodeCommit para o projeto DIO Kubernetes/MySQL"
  default_branch  = "main"

  tags = {
    Name        = var.codecommit_repo_name
    Environment = var.environment
  }
}
