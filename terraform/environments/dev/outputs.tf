output "frontend_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.frontend.cloudfront_domain_name
}

output "api_endpoint" {
  description = "API Gateway endpoint"
  value       = module.backend.api_endpoint
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.auth.user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "Cognito User Pool Client ID"
  value       = module.auth.user_pool_client_id
}

output "cognito_identity_pool_id" {
  description = "Cognito Identity Pool ID"
  value       = module.auth.identity_pool_id
}

output "cognito_domain" {
  description = "Cognito domain"
  value       = module.auth.cognito_domain
}

output "nameservers" {
  value = module.networking.nameservers
  description = "The nameservers for the Route53 zone"
}

