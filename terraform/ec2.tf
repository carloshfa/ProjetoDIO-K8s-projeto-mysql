# Security Group para a instância EC2 auxiliar.
# Esta instância é opcional e serve para operações de suporte e deploy.
resource "aws_security_group" "ec2" {
  name        = "${var.environment}-ec2-sg"
  description = "Segurança para a instância EC2 auxiliar"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-ec2-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "aux" {
  count                 = var.enable_aux_ec2 ? 1 : 0
  ami                   = data.aws_ami.amazon_linux_latest.id
  instance_type         = var.instance_type
  subnet_id             = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  associate_public_ip_address = true
  key_name              = var.ec2_key_name != "" ? var.ec2_key_name : null

  # Script de inicialização para preparar a instância EC2 com Docker e Git.
  # Esta configuração permite que o servidor auxiliar execute tarefas de build/depuração.
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y amazon-linux-extras git
              amazon-linux-extras enable docker
              yum install -y docker
              systemctl enable --now docker
              usermod -aG docker ec2-user
              EOF

  tags = {
    Name        = "${var.environment}-aux-ec2"
    Environment = var.environment
  }
}

data "aws_ami" "amazon_linux_latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["137112412989"]
}
