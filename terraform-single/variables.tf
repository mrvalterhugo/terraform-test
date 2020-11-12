variable "aws_region" {}
variable "aws_profile" {}
data "aws_availability_zones" "available" {}
variable "vpc_cidr" {}
variable "localip" {}
variable "key_name" {}
variable "user_data" {}
variable "WEB_domain" {}
variable "route53-zone-id" {}

variable "instance_type" {
  type = map
}
variable "DNS" {
  type = map
}
variable "images" {
  type = map
}
variable "cidrs" {
  type = map
}

