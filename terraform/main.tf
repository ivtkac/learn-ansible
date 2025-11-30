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

  user_data = <<EOF
    #!/bin/bash

    # Install Ansible
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get install ansible -y

    # Setup SSH key for ansible user
    mkdir -p /home/ubuntu/.ssh
    cat <<'SSHKEY' > /home/ubuntu/.ssh/id_rsa
    ${tls_private_key.generated_key.private_key_pem}
    SSHKEY

    chmod 600 /home/ubuntu/.ssh/id_rsa
    chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa

    # Create Ansible inventory
    cat <<'INVENTORY' > /etc/ansible/hosts
    [webservers]
    ${join("\n", formatlist("%s  # %s", aws_instance.web_servers[*].private_ip, aws_instance.web_servers[*].tags.Name))}
    INVENTORY
  EOF

  tags = {
    Name = "ansible-control"
  }

  depends_on = [aws_instance.web_servers]
}


resource "aws_instance" "web_servers" {
  count         = length(var.web_servers)
  ami           = var.ami
  instance_type = var.instance
  key_name      = aws_key_pair.ansible_key_pair.key_name

  tags = {
    Name = element(var.web_servers, count.index)
  }
}

