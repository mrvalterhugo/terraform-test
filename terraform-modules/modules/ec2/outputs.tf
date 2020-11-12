output "EC2_Public_IP" {
  value       = aws_instance.EC2_instance.public_ip
  description = "The EC2 instance IP"
}
output "EC2_instance" {
  value = aws_instance.EC2_instance
}
