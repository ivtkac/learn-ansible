output "ansible_control_server_public_ip" {
  value       = aws_instance.ansible_control_server.public_ip
  description = "Public IP for Ansible control server"
}

output "proxy_public_ip" {
  value       = aws_instance.web_servers[0].public_ip
  description = "Public IP of proxy server"
}

output "backend_private_ip" {
  value       = aws_instance.web_servers[1].private_ip
  description = "Private IP of backend server"
}

output "frontend_private_ip" {
  value       = aws_instance.web_servers[2].private_ip
  description = "Private IP of frontend server"
}

output "web_sever_public_dns" {
  value       = aws_instance.web_servers[0].public_dns
  description = "Public DNS of web servers"
}
