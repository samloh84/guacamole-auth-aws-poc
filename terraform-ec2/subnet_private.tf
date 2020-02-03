resource "aws_subnet" "private_1a" {
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "guacamole-subnet-private"
    Project = "guacamole"
    Owner = "samuel"
  }

  vpc_id = aws_vpc.vpc.id
}
resource "aws_subnet" "private_1b" {
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "guacamole-subnet-private"
    Project = "guacamole"
    Owner = "samuel"
  }

  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "guacamole-private"
    Project = "guacamole"
    Owner = "samuel"
  }

}

resource "aws_route_table_association" "private_1a" {
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.private_1a.id
}


resource "aws_route_table_association" "private_1b" {
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.private_1b.id
}


