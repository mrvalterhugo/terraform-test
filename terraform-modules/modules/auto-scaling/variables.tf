variable "VPC_ID" {
  type = string
}
variable "key_name" {
  description = "Key name for ASG instances"
  type        = string
}
variable "image" {
  description = "Image ID for ASG instances, default is debian"
  type        = string
  default     = "ami-0ef2c681c6c4ff0e9"
}
variable "ASG_VPC_Zone" {
  description = "Subnets for ASG"
  type        = list
}
variable "SG_ID" {
  description = "Security group id"
  type        = list
}
variable "ELB_TG_ARN" {
  description = "Load balancer target group ARN"
  type        = list
}
variable "instance_type" {
  description = "Instance type for ASG instances"
  type        = string
  default     = "t2.micro"
}
variable "user_data" {
  description = "User data file for ASG instances"
  type        = string
  default     = null
}
variable "public_ip_address" {
  description = "Enable public IP for ASG instances"
  type        = bool
  default     = false
}
variable "ASG_max_size" {
  description = "Max number of instances"
  type        = string
  default     = "2"
}
variable "ASG_min_size" {
  description = "Min number of instances"
  type        = string
  default     = "2"
}
variable "ASG_desired_capacity" {
  type    = string
  default = "2"
}
variable "ASG_force_delete" {
  description = "Enable force delete protection"
  type        = bool
  default     = false
}
variable "depends-on" {
  description = "Dependencies"
  type        = list
  default     = [null]
}
variable "ASG_launch_config_name" {
  description = "Auto scaling launch config name"
  type        = string
  default     = "AWS-ASG-launch_config"
}
variable "ASG_name" {
  description = "Auto scaling name"
  type        = string
  default     = "AWS-ASG"
}
variable "instance-name-tag" {
  description = "Define the name for created instances"
  type        = string
  default     = "AWS_ASG_Instance"
}
variable "health_check_type" {
  description = "ASG health check type"
  type        = string
  default     = "ELB"
}