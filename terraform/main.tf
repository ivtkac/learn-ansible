provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "ansible_control_server" {
  ami           = var.ami
  instance_type = var.instance
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
