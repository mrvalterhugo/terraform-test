variable "PUB-subnet-id" {
  description = "The public subnet ID"
  type        = string
}
variable "EIP-name" {
  description = "The Elastic IP name"
  type        = string
  default     = "AWS-EIP"
}
variable "depends-on" {
  description = "The dependecies"
  type        = list
  default     = [null]
}
variable "NAT-name" {
  description = "The NAT gateway name"
  type        = string
  default     = "AWS-NAT-gateway"
}

