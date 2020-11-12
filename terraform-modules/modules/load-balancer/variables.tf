variable "VPC_ID" {
  description = "VPC ID to be used"
  type        = string
}
variable "ELB_subnets" {
  description = "ELB Subnet lists"
  type        = list
}
variable "WEB_domain" {
  description = "Application domain name"
  type        = string
}
variable "validation_method" {
  description = "HTTPS certificate validation method"
  type        = string
}
variable "ELB_security_groups" {
  description = "ELB security groups"
  type        = list
}
variable "ELB_internal" {
  description = "ELB internal or not"
  type        = bool
  default     = true
}
variable "ELB_type" {
  description = "ELB type"
  type        = string
  default     = "application"
}
variable "ELB_protection" {
  description = "Enable ELB deletion protection"
  type        = bool
  default     = false
}
variable "ELB-name" {
  description = "ELB name"
  type        = string
  default     = "AWS-ELB"
}
variable "ELB_TG_name" {
  description = "ELB target group name"
  type        = string
  default     = "ELB_TG"
}
variable "ELB_TG_port" {
  description = "ELB target group port"
  type        = string
  default     = "80"
}
variable "ELB_TG_protocol" {
  description = "ELB target group protocol"
  type        = string
  default     = "HTTP"
}


