####################################### CloudFront Distribution Output #######################################
output "cloudfront_domain_name" {
  value       = module.presentation.cloudfront_domain_name
  description = "The domain name of the CloudFront distribution from the presentation module"
}

output "cloudfront_distribution_arn" {
  value       = module.presentation.cloudfront_distribution_arn
  description = "The ARN of the CloudFront distribution from the presentation module"
}

output "waf_web_acl_arn" {
  description = "The ARN of the WAF Web ACL"
  value       = module.presentation.waf_web_acl_arn
}
