resource "aws_iam_role" "lambda_guacamole_config_iam_role" {
  name = "lambda_guacamole_config_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_guacamole_config_iam_policy_cloudwatch_logging" {
  name = "lambda_guacamole_config_iam_policy_cloudwatch_logging"
  path = "/"

  policy = <<EOF
{
   "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogGroup"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_guacamole_config_iam_policy_cloudwatch_logging" {
  role = aws_iam_role.lambda_guacamole_config_iam_role.name
  policy_arn = aws_iam_policy.lambda_guacamole_config_iam_policy_cloudwatch_logging.arn
}


resource "aws_iam_policy" "lambda_guacamole_config_iam_policy_ec2_describe_permissions" {
  name = "lambda_guacamole_config_iam_policy_ec2_describe_permissions"
  path = "/"

  policy = <<EOF
{
   "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_guacamole_config_iam_policy_ec2_describe_permissions" {
  role = aws_iam_role.lambda_guacamole_config_iam_role.name
  policy_arn = aws_iam_policy.lambda_guacamole_config_iam_policy_ec2_describe_permissions.arn
}

# https://www.terraform.io/docs/providers/aws/r/lambda_function.html
resource "aws_lambda_function" "guacamole_config" {
  function_name = "guacamole-config"
  handler = "index.handler"
  role = aws_iam_role.lambda_guacamole_config_iam_role.arn
  runtime = "nodejs12.x"
  filename = "../lambda-guacamole-config/output/guacamole-config.zip"
  source_code_hash = filebase64sha256("../lambda-guacamole-config/output/guacamole-config.zip")
  timeout = 300

  environment {
    variables = {
      VPC_IDS = aws_vpc.vpc.id
    }
  }
  tags = {
    Name = "guacamole-config"
    Project = "guacamole"
    Owner = "samuel"
  }
}
