variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 zone ID for the domain"
  type        = string
}