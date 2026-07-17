output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = values(aws_subnet.public)[*].id
}

output "private_subnet_ids" {
  value = values(aws_subnet.private)[*].id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "aux_ec2_public_ip" {
  value = var.enable_aux_ec2 ? aws_instance.aux[0].public_ip : null
}

output "codecommit_clone_url_http" {
  value = var.enable_codecommit ? aws_codecommit_repository.repo[0].clone_url_http : null
}
