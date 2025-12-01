locals {
  key_name    = aws_key_pair.ansible_key_pair.key_name
  allow_ssh   = aws_security_group.ssh_sg.id
  allow_proxy = aws_security_group.proxy_sg.id
}

resource "aws_instance" "ansible_control_server" {
  ami                         = var.ami
  instance_type               = var.instance
  key_name                    = local.key_name
  vpc_security_group_ids      = [local.allow_ssh]
  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/templates/ansible_install.sh.tftpl", {
    private_key = tls_private_key.generated_key.private_key_pem
    webservers  = aws_instance.web_servers[*]
  })

  tags = {
    Name = "ansible-control"
  }

  depends_on = [aws_instance.web_servers]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.generated_key.private_key_pem
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "${path.root}/../ansible"
    destination = "/home/ubuntu/ansible"
  }
}

resource "aws_instance" "web_servers" {
  count                  = length(var.web_servers)
  ami                    = var.ami
  instance_type          = var.instance
  key_name               = local.key_name
  vpc_security_group_ids = var.web_servers[count.index] == "proxy-server" ? [local.allow_ssh, local.allow_proxy] : [local.allow_ssh]

  tags = {
    Name = element(var.web_servers, count.index)
  }
}
