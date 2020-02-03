resource "aws_security_group" "private" {
  name = "guacamole-private"
  vpc_id = aws_vpc.vpc.id
  revoke_rules_on_delete = true

  tags = {
    Name = "guacamole-private"
    Project = "guacamole"
    Owner = "samuel"
  }
}


resource "aws_security_group_rule" "public_ssh_ingress_from_private" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.private.id
  source_security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_rdp_tcp_ingress_from_private" {
  type = "ingress"
  from_port = 3389
  to_port = 3389
  protocol = "tcp"
  security_group_id = aws_security_group.private.id
  source_security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_rdp_udp_ingress_from_private" {
  type = "ingress"
  from_port = 3389
  to_port = 3389
  protocol = "udp"
  security_group_id = aws_security_group.private.id
  source_security_group_id = aws_security_group.public.id
}


resource "aws_security_group_rule" "public_https_ingress_from_private" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.private.id
  source_security_group_id = aws_security_group.public.id
}


resource "aws_security_group_rule" "private_all_ingress_from_private" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.private.id
  source_security_group_id = aws_security_group.private.id
}

resource "aws_security_group_rule" "private_all_egress_to_internet" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.private.id
  cidr_blocks = [
    "0.0.0.0/0"]
}

