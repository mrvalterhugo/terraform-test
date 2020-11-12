#-------Security Group----------
resource "aws_security_group" "AWS_SG" {
  name   = var.SG_name
  vpc_id = var.VPC_ID
  ingress {
    from_port       = var.ingress_from_port
    to_port         = var.ingress_to_port
    protocol        = var.ingress_protocol
    cidr_blocks     = var.ingress_allow_from_cidr_blocks
    security_groups = var.ingress_allow_from_SG
  }
  egress {
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_protocol
    cidr_blocks = var.egress_cidr_blocks
  }
  tags = {
    Name = var.SG_name
  }
}