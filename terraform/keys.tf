resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ansible_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.generated_key.public_key_openssh
}


resource "local_sensitive_file" "private_key" {
  content  = tls_private_key.generated_key.private_key_pem
  filename = "${path.module}/../private.pem"
  file_permission = "0400"
}
