
output "ansible_control_server_public_ip" {
  value       = aws_instance.ansible_control_server.public_ip
  description = "Public IP for Ansible control server"
}

output "web_servers_public_ips" {
  value       = aws_instance.web_servers[*].public_ip
  description = "Public IPs of web servers"
}

output "web_servers_public_dns" {
  value       = aws_instance.web_servers[*].public_dns
  description = "Public DNS of web servers"
}
