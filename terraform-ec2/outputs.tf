output "guacamole_ip" {
  value = aws_instance.guacamole_jumphost.public_ip
}

output "centos_ip" {
  value = aws_instance.centos_workload.private_ip
}

output "windows_ip" {
  value = aws_instance.windows_server_2019_workload.private_ip
}

