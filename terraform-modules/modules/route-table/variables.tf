variable "VPC-ID" {
  description = "The VPC ID"
  type        = string
}
variable "Gateway-ID" {
  description = "The internet gateway ID for public route tables"
  type        = string
  default     = null
}
variable "NAT-ID" {
  description = "The NAT gateway ID for private route table"
  type        = string
  default     = null
}
variable "name" {
  description = "The route table name"
  type        = string
  default     = "AWS-RT"
}
variable "RT_cidr_block" {
  description = "The CIDR block for the route table"
  type        = string
  default     = "0.0.0.0/0"
}
