locals {
  key_name = aws_key_pair.ansible_key_pair.key_name
}

resource "aws_instance" "ansible_control_server" {
  ami                         = var.ami
  instance_type               = var.instance
  key_name                    = local.key_name
  vpc_security_group_ids      = [aws_security_group.ansible_sg.id]
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

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for web servers to be ready...'",
      "sleep 60",
      "cd /home/ubuntu/ansible",
      "ansible-playbook playbook.yml"
    ]
  }
}

resource "aws_instance" "web_servers" {
  count                  = length(var.web_servers)
  ami                    = var.ami
  instance_type          = var.instance
  key_name               = local.key_name
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]

  tags = {
    Name = element(var.web_servers, count.index)
  }
}
