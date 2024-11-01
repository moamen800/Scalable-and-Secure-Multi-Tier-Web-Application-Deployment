####################################### Origin Access Control (OAC) #######################################
# This section defines the Origin Access Control for securing access to the S3 bucket
# through CloudFront. It ensures that all requests to the S3 origin are signed using 
# AWS SigV4 signing protocol for enhanced security.

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "OAC-for-S3-${var.s3_bucket_name}"                              # Name for the Origin Access Control, using the S3 bucket ID for uniqueness
  origin_access_control_origin_type = "s3"                                                            # Specifies that the origin is an S3 bucket
  signing_behavior                  = "always"                                                        # Ensures that all requests to the S3 origin are signed by CloudFront
  signing_protocol                  = "sigv4"                                                         # Uses the AWS SigV4 signing protocol, required for signed requests to S3
  description                       = "Origin Access Control for S3 bucket access through CloudFront" # Description for this OAC configuration
}

####################################### CloudFront Distribution #######################################
# This section defines the CloudFront distribution configuration, including the origin settings,
# cache behaviors, and viewer certificate. It ensures secure access and optimized delivery of
# content stored in the S3 bucket.

resource "aws_cloudfront_distribution" "cdn" {
  enabled = true # Enable the distribution

  origin {
    domain_name              = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name # Use bucket's regional domain
    origin_id                = "S3-${aws_s3_bucket.frontend_bucket.id}"                  # Unique origin identifier
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id               # Attach OAC for secure access
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]                          # Allow GET and HEAD requests
    cached_methods         = ["GET", "HEAD"]                          # Cache these methods
    target_origin_id       = "S3-${aws_s3_bucket.frontend_bucket.id}" # Reference the S3 origin
    viewer_protocol_policy = "redirect-to-https"                      # Enforce HTTPS for security

    min_ttl     = 0     # Minimum cache TTL (0 seconds)
    default_ttl = 3600  # Default TTL (1 hour)
    max_ttl     = 86400 # Maximum TTL (1 day)
    compress    = true  # Enable automatic compression of objects

    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Amazon's Managed Cache Policy: CachingOptimized
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # Amazon's Managed Origin Request Policy: AllViewer
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" # No geographic restrictions
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true # Use CloudFront's default SSL certificate
  }

  # price_class = "PriceClass_ALL"   
  web_acl_id = aws_wafv2_web_acl.WAF_web_acl.arn  # Attach the WAF Web ACL
}

