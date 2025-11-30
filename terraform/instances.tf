locals {
  ansible_inventory = join("\n", formatlist("%s  # %s",
    aws_instance.web_servers[*].private_ip,
    aws_instance.web_servers[*].tags.Name
  ))
}

resource "aws_instance" "ansible_control_server" {
  ami                         = var.ami
  instance_type               = var.instance
  key_name                    = aws_key_pair.ansible_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.ansible_sg.id]
  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    private_key = tls_private_key.generated_key.private_key_pem
    inventory   = local.ansible_inventory
  })

  tags = {
    Name = "ansible-control"
  }

  depends_on = [aws_instance.web_servers]
}

resource "aws_instance" "web_servers" {
  count                  = length(var.web_servers)
  ami                    = var.ami
  instance_type          = var.instance
  key_name               = aws_key_pair.ansible_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]

  tags = {
    Name = element(var.web_servers, count.index)
  }
}
