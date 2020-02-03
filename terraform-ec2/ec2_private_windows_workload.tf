resource "aws_instance" "windows_server_2019_workload" {
  ami = data.aws_ami.windows_server.id
  instance_type = "t3.small"

  vpc_security_group_ids = [
    aws_security_group.private.id]

  subnet_id = aws_subnet.private_1a.id

  key_name = aws_key_pair.guacamole.key_name

  credit_specification {
    cpu_credits = "unlimited"
  }

//  user_data = <<-EOF
//#cloud-config
//script:
//  - |
//    <powershell>
//    (Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -ComputerName $server -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0)
//    </powershell>
//  - net user administrator "${var.password}"
//EOF


  tags = {
    Name = "guacamole-windows-server-2019-workload"
    Project = "guacamole"
    Owner = "samuel"
    "Custodian-Scheduler-StopTime" = "off=();tz=sgt"
  }
}

