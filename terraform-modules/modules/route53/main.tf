#------Route53 DNS-------
resource "aws_route53_record" "DNS_Record" {
  zone_id    = var.route53-zone-id
  name       = var.DNS-name
  type       = var.record-type
  ttl        = var.DNS_TTL
  records    = [var.record-values]
  depends_on = [var.dependencies]
}