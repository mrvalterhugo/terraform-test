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

module "vpc" {
  source   = "../../modules/vpc"
  VPC_CIDR = var.VPC_CIDR
  VPC_name = "WEB_VPC"
  IG_name  = "WEB_IG"
}

module "NAT-gateway" {
  source        = "../../modules/nat-gateway"
  EIP-name      = "NAT-EIP"
  NAT-name      = "NAT-Gateway"
  PUB-subnet-id = module.ELB_public_subnet_1.subnet-ID
  depends-on    = [module.vpc.gateway-ID]
}
module "public-RT" {
  source     = "../../modules/route-table"
  name       = "public-RT"
  VPC-ID     = module.vpc.VPC_ID
  Gateway-ID = module.vpc.gateway-ID
  NAT-ID     = null
}
module "private-RT" {
  source     = "../../modules/route-table"
  name       = "private-RT"
  VPC-ID     = module.vpc.VPC_ID
  Gateway-ID = null
  NAT-ID     = module.NAT-gateway.NAT_Gateway-ID
}

module "ELB_public_subnet_1" {
  source        = "../../modules/subnet"
  name          = "ELB_public_subnet_1"
  VPC-ID        = module.vpc.VPC_ID
  RT-ID         = module.public-RT.Route-Table-ID
  AZ-index      = "0"
  subnet-cidr   = var.subnet_cidrs["ELB_public_subnet_1"]
  map_public_ip = true
}

module "ELB_public_subnet_2" {
  source        = "../../modules/subnet"
  name          = "ELB_public_subnet_2"
  VPC-ID        = module.vpc.VPC_ID
  RT-ID         = module.public-RT.Route-Table-ID
  AZ-index      = "1"
  subnet-cidr   = var.subnet_cidrs["ELB_public_subnet_2"]
  map_public_ip = true
}

module "bastion_public_subnet_1" {
  source        = "../../modules/subnet"
  name          = "bastion_public_subnet_1"
  VPC-ID        = module.vpc.VPC_ID
  RT-ID         = module.public-RT.Route-Table-ID
  AZ-index      = "0"
  subnet-cidr   = var.subnet_cidrs["bastion_public_subnet_1"]
  map_public_ip = true
}

module "WEB_private_subnet_1" {
  source        = "../../modules/subnet"
  name          = "WEB_private_subnet_1"
  VPC-ID        = module.vpc.VPC_ID
  RT-ID         = module.private-RT.Route-Table-ID
  AZ-index      = "0"
  subnet-cidr   = var.subnet_cidrs["WEB_private_subnet_1"]
  map_public_ip = false
}

module "WEB_private_subnet_2" {
  source        = "../../modules/subnet"
  name          = "WEB_private_subnet_2"
  VPC-ID        = module.vpc.VPC_ID
  RT-ID         = module.private-RT.Route-Table-ID
  AZ-index      = "1"
  subnet-cidr   = var.subnet_cidrs["WEB_private_subnet_2"]
  map_public_ip = false
}
module "bastion_SG" {
  source                         = "../../modules/security-group"
  SG_name                        = "bastion-SG"
  VPC_ID                         = module.vpc.VPC_ID
  ingress_allow_from_cidr_blocks = ["0.0.0.0/0"]
  ingress_from_port              = "22"
  ingress_to_port                = "22"
}
module "bastion-host" {
  source        = "../../modules/ec2"
  EBS_size      = "30"
  key_name      = var.ec2-key-name
  EC2_name      = "bastion_host"
  EC2_Public_IP = true
  image         = var.images["debian"]
  instance_type = var.instance_type["micro"]
  VPC_ID        = module.vpc.VPC_ID
  subnet_ID     = module.bastion_public_subnet_1.subnet-ID
  SG_ID         = [module.bastion_SG.SG-ID]
}
module "WEB-HTTP-ELB-SG" {
  source                         = "../../modules/security-group"
  SG_name                        = "WEB-HTTP-ELB-SG"
  VPC_ID                         = module.vpc.VPC_ID
  ingress_allow_from_cidr_blocks = ["0.0.0.0/0"]
  ingress_from_port              = "80"
  ingress_to_port                = "80"
}
module "WEB-HTTPS-ELB-SG" {
  source                         = "../../modules/security-group"
  SG_name                        = "WEB-HTTPS-ELB-SG"
  VPC_ID                         = module.vpc.VPC_ID
  ingress_allow_from_cidr_blocks = ["0.0.0.0/0"]
  ingress_from_port              = "443"
  ingress_to_port                = "443"
}
module "WEB-ELB" {
  source              = "../../modules/load-balancer"
  ELB-name            = "WEB-ELB"
  VPC_ID              = module.vpc.VPC_ID
  WEB_domain          = var.ELB-domain-name
  validation_method   = "EMAIL"
  ELB_internal        = false
  ELB_subnets         = [module.ELB_public_subnet_1.subnet-ID, module.ELB_public_subnet_2.subnet-ID]
  ELB_security_groups = [module.WEB-HTTP-ELB-SG.SG-ID, module.WEB-HTTPS-ELB-SG.SG-ID]
  ELB_TG_name         = "WEB-ELB-TG"
}
module "ASG-SSH-SG" {
  source                = "../../modules/security-group"
  SG_name               = "ASG-SSH-SG"
  VPC_ID                = module.vpc.VPC_ID
  ingress_allow_from_SG = [module.bastion_SG.SG-ID]
  ingress_from_port     = "22"
  ingress_to_port       = "22"
}
module "ASG-HTTP-SG" {
  source                = "../../modules/security-group"
  SG_name               = "ASG-HTTP-SG"
  VPC_ID                = module.vpc.VPC_ID
  ingress_allow_from_SG = [module.WEB-HTTPS-ELB-SG.SG-ID, module.bastion_SG.SG-ID]
  ingress_from_port     = "80"
  ingress_to_port       = "80"
}
module "WEB-ASG" {
  source                 = "../../modules/auto-scaling"
  ASG_name               = "WEB-ASG"
  VPC_ID                 = module.vpc.VPC_ID
  key_name               = var.ec2-key-name
  image                  = var.images["debian"]
  instance_type          = var.instance_type["micro"]
  user_data         = file(var.user_data)
  public_ip_address      = false
  ASG_max_size           = "3"
  ASG_min_size           = "2"
  ASG_desired_capacity   = "2"
  ASG_force_delete       = false
  ASG_VPC_Zone           = [module.WEB_private_subnet_1.subnet-ID, module.WEB_private_subnet_2.subnet-ID]
  ELB_TG_ARN             = [module.WEB-ELB.ELB_TG_ARN]
  depends-on             = [module.NAT-gateway.NAT_Gateway-ID]
  ASG_launch_config_name = "WEB-ASG-launch-config"
  SG_ID                  = [module.ASG-SSH-SG.SG-ID, module.ASG-HTTP-SG.SG-ID]
  instance-name-tag      = "WEB-ASG-instance"

}

module "ELB-DNS" {
  source          = "../../modules/route53"
  route53-zone-id = var.route53-zone-id
  DNS-name        = "www"
  record-type     = "CNAME"
  record-values   = module.WEB-ELB.ELB_Public_DNS_Name
  dependencies    = [module.WEB-ELB.AWS_ELB]
}
module "Bastion-DNS" {
  source          = "../../modules/route53"
  route53-zone-id = var.route53-zone-id
  DNS-name        = "dev-host"
  record-type     = "A"
  record-values   = module.bastion-host.EC2_Public_IP
  dependencies    = [module.bastion-host.EC2_instance]
}

#---------Outputs ----------
output "ELB_Public_DNS_Name" {
  value = module.WEB-ELB.ELB_Public_DNS_Name
}
output "Bastion_public_IP" {
  value = module.bastion-host.EC2_Public_IP
}
output "ELB_DNS_Name" {
  value = module.ELB-DNS.FQDN_name
}
output "Bastion_DNS_Name" {
  value = module.Bastion-DNS.FQDN_name
}