provider "aws" {
  profile = "default"
  region  = var.region
}

resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ansible_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.generated_key.public_key_openssh
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.generated_key.private_key_pem
  filename        = "${path.module}/../private.pem"
  file_permission = "0400"
}

resource "aws_security_group" "ansible_sg" {
  name        = "ansible-security-group"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "ansible-sg"
  }
}

resource "aws_instance" "ansible_control_server" {
  ami                    = var.ami
  instance_type          = var.instance
  key_name               = aws_key_pair.ansible_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]

  tags = {
    Name = "ansible-control"
  }
}

resource "aws_instance" "web_servers" {
  count         = length(var.web_servers)
  ami           = var.ami
  instance_type = var.instance
  tags = {
    Name = element(var.web_servers, count.index)
  }
}
