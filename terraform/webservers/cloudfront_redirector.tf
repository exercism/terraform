# locals {
#   s3_redirector_origin_id = "redirector"
# }

# resource "aws_cloudfront_origin_access_identity" "redirector" {
#   comment = "Original Access Identity for redirector"
# }


# resource "aws_s3_bucket" "redirector" {
#   bucket = "exercism-v3-redirector"
#   acl    = "public-read"

#   website {
#     redirect_all_requests_to = "https://exercism.org"
#   }
# }

# resource "aws_cloudfront_distribution" "redirector" {
#   enabled         = true
#   is_ipv6_enabled = true
#   aliases = [
#     # "exercism.io",
#     # "www.exercism.io",
#     "exercism.net",
#     "exercism.com",
#     # "exercism.lol",
#     # "www.exercism.lol"
#   ]

#   origin {
#     domain_name = aws_s3_bucket.redirector.bucket_regional_domain_name
#     origin_id   = local.s3_redirector_origin_id

#     s3_origin_config {
#       origin_access_identity = aws_cloudfront_origin_access_identity.redirector.cloudfront_access_identity_path
#     }
#   }

#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = local.s3_redirector_origin_id

#     forwarded_values {
#       query_string = true
#       headers      = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]

#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "redirect-to-https"
#     min_ttl                = 0
#     default_ttl            = 0
#     max_ttl                = 0
#     compress               = true
#   }
#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     acm_certificate_arn = var.acm_certificate_arn
#     ssl_support_method  = "sni-only"
#   }
# }

