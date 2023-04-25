provider "aws" {
  region = var.AWS_REGION
}

locals {
  oai_arn    = aws_cloudfront_origin_access_identity.default.iam_arn
  depends_on = [aws_cloudfront_origin_access_identity.default]
}

resource "aws_cloudfront_origin_access_identity" "default" {
  comment = var.bucket_name
}

resource "aws_s3_bucket" "s3bucket" {
  bucket = var.bucket_name
  acl    = "private"
  tags = {
    Name        = var.bucket_name
    Environment = "${var.ENV_TAG}"
  }
  policy = templatefile("s3_policy.tpl", { bucket_name = var.bucket_name, oai_arn = local.oai_arn })
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  depends_on = [aws_cloudfront_origin_access_identity.default]
}

resource "aws_s3_bucket_object" "s3_bucket_object" {
  key          = "index.html"
  bucket       = aws_s3_bucket.s3bucket.id
  source       = "index.html"
  content_type = "text/html"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.s3bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.s3bucket.id

    s3_origin_config {
      origin_access_identity = format("origin-access-identity/cloudfront/%s", aws_cloudfront_origin_access_identity.default.id)
    }
  }
  enabled         = true
  is_ipv6_enabled = true
  comment         = var.cloudfront_comment
  # comment = "${terraform.workspace}.birthmodel.com"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.s3bucket.id
    cache_policy_id  = format("%s", "${var.cachePolicyId}")
    # forwarded_values {
    #       query_string = false
    #       cookies {
    #         forward = "none"
    #       }
    #     }  
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  custom_error_response {
    error_caching_min_ttl = 3000
    error_code            = 400
    response_code         = 200
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = 3000
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  price_class = "PriceClass_200"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [aws_s3_bucket.s3bucket]
}

resource "null_resource" "Testing" {
  provisioner "local-exec" {
    command = "curl http://${aws_cloudfront_distribution.s3_distribution.domain_name}"
  }
}
