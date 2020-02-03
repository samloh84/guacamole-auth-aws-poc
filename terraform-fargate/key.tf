resource "aws_key_pair" "guacamole" {
  key_name = "guacamole2"
  public_key = file("~/.ssh/guacamole.pub")
}
