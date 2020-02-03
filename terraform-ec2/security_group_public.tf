data "http" "local_ip" {
  url = "https://ipv4.icanhazip.com/"
}

locals {
  local_cidr = "${chomp(data.http.local_ip.body)}/32"
}


resource "aws_security_group" "public" {
  name = "guacamole-public"
  vpc_id = aws_vpc.vpc.id
  revoke_rules_on_delete = true



  tags = {
    Name = "guacamole-public"
    Project = "guacamole"
    Owner = "samuel"
  }
}

resource "aws_security_group_rule" "public_https_ingress_from_local_cidr" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.public.id
  cidr_blocks = [
    local.local_cidr]
}

resource "aws_security_group_rule" "public_ssh_ingress_from_local_cidr" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.public.id
  cidr_blocks = [
    local.local_cidr]
}


resource "aws_security_group_rule" "public_all_ingress_from_public" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.public.id
  source_security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_all_egress_to_internet" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.public.id
  cidr_blocks = [
    "0.0.0.0/0"]
}

