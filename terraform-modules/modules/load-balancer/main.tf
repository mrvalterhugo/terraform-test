#----------HTTPS Certificate----------
resource "aws_acm_certificate" "ELB_certificate" {
  domain_name       = var.WEB_domain
  validation_method = var.validation_method
}
#------Load Balancer-------------
resource "aws_lb" "AWS_ELB" {
  name                       = var.ELB-name
  internal                   = var.ELB_internal
  load_balancer_type         = var.ELB_type
  security_groups            = var.ELB_security_groups
  subnets                    = var.ELB_subnets
  enable_deletion_protection = var.ELB_protection
}
#--------ELB Target Group-------------
resource "aws_alb_target_group" "ELB_TG" {
  name     = var.ELB_TG_name
  port     = var.ELB_TG_port
  protocol = var.ELB_TG_protocol
  vpc_id   = var.VPC_ID
}
#--------ELB Listeners--------------
resource "aws_lb_listener" "ELB_HTTPS_listener" {
  load_balancer_arn = aws_lb.AWS_ELB.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ELB_certificate.arn
  depends_on        = [aws_acm_certificate.ELB_certificate]
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ELB_TG.arn
  }
}
resource "aws_lb_listener" "ELB_HTTP_listener" {
  load_balancer_arn = aws_lb.AWS_ELB.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
