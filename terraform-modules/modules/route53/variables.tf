variable "route53-zone-id" {
  description = "Hosted zone ID number"
  type        = string
}
variable "DNS-name" {
  description = "Record name"
  type        = string
}
variable "record-values" {
  description = "DNS record values"
  type        = string
}
variable "record-type" {
  description = "DNS record type"
  type        = string
  default     = "A"
}
variable "dependencies" {
  type    = list
  default = [null]
}
variable "DNS_TTL" {
  type    = string
  default = "300"
}