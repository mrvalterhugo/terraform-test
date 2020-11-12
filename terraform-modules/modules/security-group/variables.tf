variable "SG_name" {
  description = "Name tag for the security group"
  type        = string
  default     = "EC2-SG"
}
variable "VPC_ID" {
  description = "VPC ID to be used"
  type        = string
}
variable "ingress_allow_from_cidr_blocks" {
  description = "Allow access from this IP range"
  type        = list
  default     = null
}
variable "ingress_allow_from_SG" {
  description = "Allow access from this security group"
  type        = list
  default     = null
}
variable "ingress_from_port" {
  description = "ingress from port range"
  type        = string
}
variable "ingress_to_port" {
  description = "ingress to port range"
  type        = string
}
variable "ingress_protocol" {
  description = "protocol to be used on ingress rule"
  type        = string
  default     = "tcp"
}
variable "egress_cidr_blocks" {
  description = "Allow access to this CIDR block"
  type        = list
  default     = ["0.0.0.0/0"]
}
variable "egress_protocol" {
  description = "protocol to be used on egress rule"
  type        = string
  default     = "-1"
}
variable "egress_from_port" {
  description = "egress from port range"
  type        = string
  default     = "0"
}
variable "egress_to_port" {
  description = "egress to port range"
  type        = string
  default     = "0"
}


