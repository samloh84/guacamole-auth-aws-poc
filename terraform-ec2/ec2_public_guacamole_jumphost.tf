resource "aws_iam_role" "guacamole_jumphost_iam_role" {
  name = "guacamole_jumphost_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy" "guacamole_jumphost_iam_policy_invoke_lambda_guacamole_config" {
  name = "guacamole_jumphost_iam_policy_invoke_lambda_guacamole_config"
  path = "/"

  policy = <<EOF
{
   "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["lambda:InvokeFunction"],
      "Resource": "${aws_lambda_function.guacamole_config.arn}",
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "guacamole_jumphost_iam_policy_invoke_lambda_guacamole_config" {
  role = aws_iam_role.guacamole_jumphost_iam_role.name
  policy_arn = aws_iam_policy.guacamole_jumphost_iam_policy_invoke_lambda_guacamole_config.arn
}

resource "aws_iam_instance_profile" "guacamole_jumphost_instance_profile" {
  name = "guacamole_jumphost_instance_profile"
  role = aws_iam_role.guacamole_jumphost_iam_role.name
}

//data "template_file" "ec2_public_guacamole_jumphost_guacamole_docker_compose" {
//  template = file("ec2_public_guacamole_jumphost_guacamole-docker-compose.yml")
//  vars = {
//    OPENID_AUTHORIZATION_ENDPOINT = var.OPENID_AUTHORIZATION_ENDPOINT
//    OPENID_JWKS_ENDPOINT = var.OPENID_JWKS_ENDPOINT
//    OPENID_ISSUER = var.OPENID_ISSUER
//    OPENID_CLIENT_ID = var.OPENID_CLIENT_ID
//    OPENID_REDIRECT_URI = "https://${aws_route53_record.guacamole_hostname.fqdn}/guacamole"
//  }
//}

//data "template_file" "ec2_public_guacamole_jumphost_userdata" {
//  template = file("ec2_public_guacamole_jumphost_userdata.yml")
//  vars = {
//    GUACAMOLE_DOCKER_COMPOSE_YML = base64encode(data.template_file.ec2_public_guacamole_jumphost_guacamole_docker_compose.rendered)
//    INSTALL_AWS_CLI_SH = base64encode(file("guacamole-scripts/install-aws-cli.sh"))
//    INSTALL_DOCKER_SH = base64encode(file("guacamole-scripts/install-docker.sh"))
//  }
//}

resource "aws_instance" "guacamole_jumphost" {
  ami = data.aws_ami.centos.id
  instance_type = "t3.small"

  vpc_security_group_ids = [
    aws_security_group.public.id]

  subnet_id = aws_subnet.public_1a.id

  key_name = aws_key_pair.guacamole.key_name


  iam_instance_profile = aws_iam_instance_profile.guacamole_jumphost_instance_profile.name
//  user_data = data.template_file.ec2_public_guacamole_jumphost_userdata.rendered

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "guacamole-jumphost"
    Project = "guacamole"
    Owner = "samuel"
    "Custodian-Scheduler-StopTime" = "off=();tz=sgt"
  }

}




