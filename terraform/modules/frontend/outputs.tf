output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.frontend.domain_name
  description = "CloudFront distribution domain name"
}

output "cloudfront_hosted_zone_id" {
  value       = aws_cloudfront_distribution.frontend.hosted_zone_id
  description = "CloudFront distribution hosted zone ID"
}

output "frontend_bucket_name" {
  value       = aws_s3_bucket.frontend.id
  description = "Name of the S3 bucket for frontend"
}