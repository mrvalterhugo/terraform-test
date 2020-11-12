variable "VPC_CIDR" {
  description = "The VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}
variable "VPC_name" {
  description = "The VPC name"
  type        = string
  default     = "AWS-VPC"
}
variable "IG_name" {
  description = "The IG name"
  type        = string
  default     = "AWS-IG"
}
variable "VPC_DNS_hostnames" {
  description = "Enable VPC DNS hostnames"
  type        = string
  default     = true
}
variable "VPC_DNS_support" {
  description = "Enable VPC DNS support"
  type        = string
  default     = true
}
