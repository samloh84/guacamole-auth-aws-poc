data aws_route53_zone public {
  private_zone = false
  name = var.public_zone_name
}


resource "aws_route53_record" "guacamole_hostname" {
  zone_id = data.aws_route53_zone.public.id
  name = "guacamole.${trimsuffix(data.aws_route53_zone.public.name,".")}"
  type = "A"
  alias {
    evaluate_target_health = true
    name = aws_lb.guacamole.dns_name
    zone_id = aws_lb.guacamole.zone_id
  }
}

resource "aws_acm_certificate" "guacamole_cert" {
  domain_name = aws_route53_record.guacamole_hostname.fqdn
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_acm_certificate_validation" "guacamole_cert" {
  certificate_arn = aws_acm_certificate.guacamole_cert.arn
  validation_record_fqdns = [
    aws_route53_record.guacamole_cert_validation.fqdn]
}


resource "aws_route53_record" "guacamole_cert_validation" {
  name = aws_acm_certificate.guacamole_cert.domain_validation_options[0].resource_record_name
  type = aws_acm_certificate.guacamole_cert.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.public.id
  records = [
    aws_acm_certificate.guacamole_cert.domain_validation_options[0].resource_record_value]
  ttl = 60
}


resource "aws_lb" "guacamole" {
  name = "guacamole-lb-tf"
  internal = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.public.id]
  subnets = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1b.id]

}

resource "aws_lb_target_group" "guacamole" {
  name = "guacamole-lb-tg"
  port = 8080
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id

}

resource "aws_lb_target_group_attachment" "guacamole" {
  target_group_arn = aws_lb_target_group.guacamole.arn
  target_id = aws_instance.guacamole_jumphost.id
}

resource "aws_lb_listener" "guacamole" {
  load_balancer_arn = aws_lb.guacamole.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate_validation.guacamole_cert.certificate_arn


  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.guacamole.arn
  }
}
