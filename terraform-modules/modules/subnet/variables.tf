variable "RT-ID" {
  description = "Route table ID"
  type        = string
}
variable "VPC-ID" {
  description = "The VPC ID"
  type        = string
}
variable "subnet-cidr" {
  description = "subnet network"
  type        = string
}
variable "name" {
  description = "subnet name"
  type        = string
  default     = "AWS-subnet"
}
variable "AZ-index" {
  description = "Availability zone"
  type        = string
  default     = "0"
}

variable "map_public_ip" {
  description = "map public IP or not"
  type        = bool
  default     = false
}
