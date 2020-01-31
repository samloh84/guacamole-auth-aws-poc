resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "guacamole-vpc"
    Project = "guacamole"
    Owner = "samuel"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "guacamole"
    Project = "guacamole"
    Owner = "samuel"
  }
}
