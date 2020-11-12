variable "key_name" {
  description = "Key name in AWS for EC2"
  type        = string
}
variable "subnet_ID" {
  description = "Subnet ID to be used"
  type        = string
}
variable "SG_ID" {
  description = "Security groups IDs to be used"
  type        = list
}
variable "VPC_ID" {
  description = "VPC ID to be used"
  type        = string
}
variable "user_data" {
  description = "User data file for the EC2 instances"
  type        = string
  default     = null
}
variable "image" {
  description = "Amazon EC2 AMI - default is debian"
  type        = string
  default     = "ami-0ef2c681c6c4ff0e9"
}
variable "EBS_size" {
  description = "EBS Volume Size for EC2"
  type        = string
  default     = "8"
}
variable "EC2_name" {
  description = "Name tag for EC2"
  type        = string
  default     = "AWS-EC2"
}
variable "instance_type" {
  description = "Instace types"
  type        = string
  default     = "t2.micro"
}
variable "localip" {
  description = "Local IP address to be used on Security Groups"
  type        = list
  default     = ["0.0.0.0./0"]
}
variable "EC2_Public_IP" {
  description = "Allow public IP to be assigned"
  type        = bool
  default     = true
}
