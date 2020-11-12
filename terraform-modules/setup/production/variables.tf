variable "aws_region" {
  description = "AWS Region"
  type        = string
}
variable "VPC_CIDR" {
  description = "VPC CIDR block o be used"
  type        = string
}
variable "ELB-domain-name" {
  description = "Domain name used for HTTPS certificate creation"
  type        = string
}

variable "user_data" {
  description = "user data to be used on EC2"
  type        = string
  default     = null
}
variable "ec2-key-name" {
  description = "Key that will be used for AWS EC2 instances"
  type        = string
}
variable "route53-zone-id" {
  description = "Route53 zone ID"
  type        = string
}
variable "instance_type" {
  description = "Instance type to be used with EC2"
  type        = map
}
variable "images" {
  description = "AMI ID to be used with AWS EC2 instances"
  type        = map
}
variable "subnet_cidrs" {
  description = "subnet CIDR to be used on the subnets"
  type        = map
}