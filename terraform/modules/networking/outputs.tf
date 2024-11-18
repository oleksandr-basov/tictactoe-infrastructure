output "certificate_arn" {
  value       = aws_acm_certificate.frontend.arn
  description = "ARN of the ACM certificate"
}

output "zone_id" {
  value       = aws_route53_zone.primary.zone_id
  description = "Route53 zone ID"
}

output "nameservers" {
  value = aws_route53_zone.primary.name_servers
  description = "The nameservers for the Route53 zone"
}

output "domain_name" {
  value       = var.domain_name
  description = "Domain name"
}
