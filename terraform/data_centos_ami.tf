// Find latest Centos AMI
data "aws_ami" "centos" {
  most_recent = true

  filter {
    name = "product-code"
    values = [
      "aw0evgkw8e5c1q413zgy5pjce"]
  }

  filter {
    name = "ena-support"
    values = [
      "true"]
  }

  filter {
    name = "owner-alias"
    values = [
      "aws-marketplace"]
  }

  owners = [
    "679593333241"
  ]
}
