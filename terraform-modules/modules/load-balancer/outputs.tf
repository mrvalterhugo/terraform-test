output "ELB_Public_DNS_Name" {
  value       = aws_lb.AWS_ELB.dns_name
  description = "The ELB public DNS name"
}
output "ELB_TG_ARN" {
  value       = aws_alb_target_group.ELB_TG.arn
  description = "ELB Target Group ARN"
}
output "AWS_ELB" {
  value = aws_lb.AWS_ELB
}