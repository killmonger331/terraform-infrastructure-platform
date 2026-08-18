resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "terraform-platform-frontend-"

  tags = {
    Name      = "terraform-platform-frontend"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "frontend" {
  name                              = "terraform-platform-frontend-oac"
  description                       = "OAC for Terraform platform frontend"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "frontend" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id                = "terraform-platform-frontend"
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend.id
  }

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    target_origin_id = "terraform-platform-frontend"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name      = "terraform-platform-frontend"
    ManagedBy = "Terraform"
  }
}

data "aws_iam_policy_document" "frontend" {
  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.frontend.arn}/*"
    ]

    principals {
      type = "Service"

      identifiers = [
        "cloudfront.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.frontend.arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.frontend.json
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "index.html"
  source       = "${var.frontend_path}/index.html"
  content_type = "text/html"

  etag = filemd5("${var.frontend_path}/index.html")
}

resource "aws_s3_object" "styles" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "css/styles.css"
  source       = "${var.frontend_path}/css/styles.css"
  content_type = "text/css"

  etag = filemd5("${var.frontend_path}/css/styles.css")
}

resource "aws_s3_object" "javascript" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "js/main.js"
  source       = "${var.frontend_path}/js/main.js"
  content_type = "application/javascript"

  etag = filemd5("${var.frontend_path}/js/main.js")
}