variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "ami" {
  type    = string
  default = "ami-03b7a7ce915b46b75" # Ubuntu 22.04 LTS eu-central-1
}

variable "instance" {
  type    = string
  default = "t2.micro"
}

variable "web_servers" {
  type    = list(string)
  default = ["proxy-server", "backend", "frontend"]
}

variable "key_name" {
  type    = string
  default = "ansible-key"
}
