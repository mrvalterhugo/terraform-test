terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}

#------VPC-------
resource "aws_vpc" "WEB_VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "WEB_VPC"
  }
}

#-----Internet Gateway---------
resource "aws_internet_gateway" "WEB_internet_gateway" {
  vpc_id = aws_vpc.WEB_VPC.id
}

#-------Elastic IP---------
resource "aws_eip" "NAT_EIP" {
  vpc        = true
  depends_on = [aws_internet_gateway.WEB_internet_gateway]
}

#-------NAT Gateway-------
resource "aws_nat_gateway" "WEB_NAT_Gateway" {
  allocation_id = aws_eip.NAT_EIP.id
  subnet_id     = aws_subnet.bastion_public_subnet_1.id
}

#--------Route Tables-------
resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.WEB_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.WEB_internet_gateway.id
  }
  tags = {
    Name = "public_RT"
  }
}

resource "aws_default_route_table" "private_RT" {
  default_route_table_id = aws_vpc.WEB_VPC.default_route_table_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.WEB_NAT_Gateway.id
  }

  tags = {
    Name = "private_RT"
  }
}

#-------- Subnets---------
resource "aws_subnet" "ELB_public_subnet_1" {
  vpc_id                  = aws_vpc.WEB_VPC.id
  cidr_block              = var.cidrs["ELB_public_subnet_1"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "ELB_public_subnet_1"
  }
}

resource "aws_subnet" "ELB_public_subnet_2" {
  vpc_id                  = aws_vpc.WEB_VPC.id
  cidr_block              = var.cidrs["ELB_public_subnet_2"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "ELB_public_subnet_1"
  }
}

resource "aws_subnet" "bastion_public_subnet_1" {
  vpc_id                  = aws_vpc.WEB_VPC.id
  cidr_block              = var.cidrs["bastion_public_subnet_1"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "bastion_public_subnet_1"
  }
}

resource "aws_subnet" "WEB_private_subnet_1" {
  vpc_id            = aws_vpc.WEB_VPC.id
  cidr_block        = var.cidrs["WEB_private_subnet_1"]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "WEB_private_subnet_1"
  }
}

resource "aws_subnet" "WEB_private_subnet_2" {
  vpc_id            = aws_vpc.WEB_VPC.id
  cidr_block        = var.cidrs["WEB_private_subnet_2"]
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "WEB_private_subnet_2"
  }
}

#--------Subnet Associations------
resource "aws_route_table_association" "ELB_public_1_assoc" {
  subnet_id      = aws_subnet.ELB_public_subnet_1.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "ELB_public_2_assoc" {
  subnet_id      = aws_subnet.ELB_public_subnet_2.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "bastion_public_1_assoc" {
  subnet_id      = aws_subnet.bastion_public_subnet_1.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "WEB_private_1_assoc" {
  subnet_id      = aws_subnet.WEB_private_subnet_1.id
  route_table_id = aws_default_route_table.private_RT.id
}

resource "aws_route_table_association" "WEB_private_2_assoc" {
  subnet_id      = aws_subnet.WEB_private_subnet_2.id
  route_table_id = aws_default_route_table.private_RT.id
}

#-------Bastion Security Group----------
resource "aws_security_group" "bastion_SG" {
  name        = "bastion_SG"
  description = "Used for the bastion instance for ssh access"
  vpc_id      = aws_vpc.WEB_VPC.id

  #SSH
  ingress {
    description = "Allow SSH - Local IP Only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Allow my IP only
    cidr_blocks = var.localip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_SG"
  }

}

#-------ELB Security Group------------
resource "aws_security_group" "ELB_SG" {
  name        = "ELB_public_SG"
  description = "Used for the Load Balancer for Web access"
  vpc_id      = aws_vpc.WEB_VPC.id

  #HTTP
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #HTTPS
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ELB_SG"
  }

}

#-------Web Security Group------------
resource "aws_security_group" "WEB_SG" {
  name        = "WEB_SG"
  description = "Used on the auto-scaling instances for Web access from the ELB"
  vpc_id      = aws_vpc.WEB_VPC.id

  #HTTP
  ingress {
    description     = "Allow HTTP from ELB and Bastion host"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ELB_SG.id]
  }

  #SSH
  ingress {
    description     = "Allow SSH from Bastion Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_SG.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WEB_SG"
  }

}

#-------EC2 Bastion Host -----------
resource "aws_instance" "bastion_host" {
  ami           = var.images["debian"]
  instance_type = var.instance_type["micro"]
  root_block_device {
    volume_size = 30
  }

  key_name = var.key_name
  vpc_security_group_ids = [
    aws_security_group.bastion_SG.id
  ]
  subnet_id                   = aws_subnet.bastion_public_subnet_1.id
  associate_public_ip_address = true
  tags = {
    Name = "Bastion Host"
  }

}

#----------HTTPS Certificate----------
resource "aws_acm_certificate" "ELB_certificate" {
  domain_name       = var.WEB_domain
  validation_method = "EMAIL"
}

#------Load Balancer-------------
resource "aws_lb" "WEB_ELB" {
  name                       = "WEB-ELB"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ELB_SG.id]
  subnets                    = [aws_subnet.ELB_public_subnet_1.id, aws_subnet.ELB_public_subnet_2.id]
  enable_deletion_protection = false
  tags = {
    Environment = "production"
  }
}

#--------ELB Target Group-------------
resource "aws_alb_target_group" "WEB_ELB_TG" {
  name     = "WEB-ELB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.WEB_VPC.id
  health_check {
    path                = "/"
    matcher             = "200"
    interval            = "30"
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
  }
}

#--------ELB Listeners--------------
resource "aws_lb_listener" "ELB_HTTPS_listener" {
  load_balancer_arn = aws_lb.WEB_ELB.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ELB_certificate.arn
  depends_on        = [aws_acm_certificate.ELB_certificate]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.WEB_ELB_TG.arn
  }
}

resource "aws_lb_listener" "ELB_HTTP_listener" {
  load_balancer_arn = aws_lb.WEB_ELB.arn
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

#------ Launch Configuration-------------
resource "aws_launch_configuration" "WEB_ASG_launch_conf" {
  name                        = "WEB_ASG_launch_conf"
  image_id                    = var.images["debian"]
  instance_type               = var.instance_type["micro"]
  key_name                    = var.key_name
  user_data                   = file(var.user_data)
  associate_public_ip_address = false
  security_groups             = [aws_security_group.WEB_SG.id]
}

#------Auto-Scaling------------
resource "aws_autoscaling_group" "WEB_ASG" {
  name                      = "WEB_ASG"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = false
  launch_configuration      = aws_launch_configuration.WEB_ASG_launch_conf.name
  vpc_zone_identifier       = [aws_subnet.WEB_private_subnet_1.id, aws_subnet.WEB_private_subnet_2.id]
  target_group_arns         = [aws_alb_target_group.WEB_ELB_TG.arn]
  tag {
    key                 = "Name"
    value               = "WEB_ASG"
    propagate_at_launch = true
  }
  timeouts {
    delete = "15m"
  }
  depends_on = [aws_nat_gateway.WEB_NAT_Gateway]
}

#------Route53 DNS-------
resource "aws_route53_record" "WEB_DNS" {
  zone_id    = var.route53-zone-id
  name       = var.DNS["ELB"]
  type       = "CNAME"
  ttl        = "300"
  records    = [aws_lb.WEB_ELB.dns_name]
  depends_on = [aws_lb.WEB_ELB]
}

resource "aws_route53_record" "bastion_DNS" {
  zone_id    = var.route53-zone-id
  name       = var.DNS["bastion"]
  type       = "A"
  ttl        = "300"
  records    = [aws_instance.bastion_host.public_ip]
  depends_on = [aws_instance.bastion_host]
}


#---------Outputs ----------
output "ELB_public_IP" {
  value = aws_lb.WEB_ELB.dns_name
}
output "Bastion_public_IP" {
  value = aws_instance.bastion_host.public_ip
}

output "ELB_DNS_Name" {
  value = aws_route53_record.WEB_DNS.fqdn
}
output "Bastion_DNS_Name" {
  value = aws_route53_record.bastion_DNS.fqdn
}
