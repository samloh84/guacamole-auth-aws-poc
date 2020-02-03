resource "aws_instance" "centos_workload" {
  ami = data.aws_ami.centos.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.private.id]

  subnet_id = aws_subnet.private_1a.id
  key_name = aws_key_pair.guacamole.key_name
  credit_specification {
    cpu_credits = "unlimited"
  }


//  user_data = <<-EOF
//#cloud-config
//runcmd:
//  - cloud-init-per once allow_sshd_password_authentication sed -e "s:#PasswordAuthentication yes:PasswordAuthentication yes:g /etc/ssh/sshd_config
//  - cloud-init-per once change_password usermod --password $(openssl passwd -1 ${var.password}) centos
//EOF

  tags = {
    Name = "guacamole-centos-workload"
    Project = "guacamole"
    Owner = "samuel"
    "Custodian-Scheduler-StopTime" = "off=();tz=sgt"
  }
}

