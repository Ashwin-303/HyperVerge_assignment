resource "aws_cloudfront_cache_policy" "default" {
  name        = "${var.env}-CachingOptimized_Custom"
  comment     = "same as CachingOptimized"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}

module "cloudfront" {
  source             = "./common"
  ENV_TAG            = var.env
  AWS_REGION         = var.aws_region
  bucket_name        = "${var.project_prefix}-${var.env}-${var.portal}-portal"
  cloudfront_comment = "${var.project_prefix}-${var.env}-${var.portal}-portal"
  cachePolicyId      = aws_cloudfront_cache_policy.default.id

}
