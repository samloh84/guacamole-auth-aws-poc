resource "aws_iam_role" "guacamole_jumphost_iam_role" {
  name = "guacamole_jumphost_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
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


resource "aws_ecs_cluster" "guacamole" {
  name = "guacamole"
  capacity_providers = [
    "FARGATE"]
}

data template_file guacamole_ecs_task_definition {
  template = file("ecs_task_definition_guacamole.json")
  vars = {
    OPENID_AUTHORIZATION_ENDPOINT = var.OPENID_AUTHORIZATION_ENDPOINT
    OPENID_JWKS_ENDPOINT = var.OPENID_JWKS_ENDPOINT
    OPENID_ISSUER = var.OPENID_ISSUER
    OPENID_CLIENT_ID = var.OPENID_CLIENT_ID
    OPENID_REDIRECT_URI = "https://${aws_route53_record.guacamole_hostname.fqdn}/guacamole"
  }

}

resource "aws_iam_role" "guacamole_jumphost_logs_iam_role" {
  name = "guacamole_jumphost_logs_iam_role"
  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}
resource "aws_iam_policy" "guacamole_jumphost_logs_iam_policy" {
  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
         "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "guacamole_jumphost_logs_iam_policy" {
  policy_arn = aws_iam_policy.guacamole_jumphost_logs_iam_policy.arn
  role = aws_iam_role.guacamole_jumphost_logs_iam_role.id
}

resource "aws_ecs_task_definition" "guacamole" {
  container_definitions = data.template_file.guacamole_ecs_task_definition.rendered
  family = "guacamole"

  task_role_arn = aws_iam_role.guacamole_jumphost_iam_role.arn
  requires_compatibilities = [
    "FARGATE"]
  network_mode = "awsvpc"
  cpu = "2048"
  memory = "4096"

  execution_role_arn = aws_iam_role.guacamole_jumphost_logs_iam_role.arn


}

resource "aws_ecs_service" "guacamole" {
  name = "guacamole"
  cluster = aws_ecs_cluster.guacamole.id
  task_definition = aws_ecs_task_definition.guacamole.arn
  desired_count = 1
  depends_on = [
    aws_iam_role_policy_attachment.guacamole_jumphost_iam_policy_invoke_lambda_guacamole_config,
    aws_lb_listener.guacamole
  ]

  network_configuration {
    security_groups = [
      aws_security_group.public.id]
    subnets = [
      aws_subnet.public_1a.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.guacamole.arn
    container_name = "guacamole"
    container_port = 8080
  }

  launch_type = "FARGATE"


}