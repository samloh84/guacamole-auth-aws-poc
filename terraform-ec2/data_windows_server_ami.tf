// Find latest Centos AMI
data "aws_ami" "windows_server" {
  most_recent = true

  filter {
    name = "platform"
    values = [
      "windows"]
  }

  filter {
    name = "name"
    values = [
      "Windows_Server-2019-English-Full-Base-*"]
  }

  filter {
    name = "ena-support"
    values = [
      "true"]
  }


  owners = [
    "self",
    "amazon"
  ]
}
