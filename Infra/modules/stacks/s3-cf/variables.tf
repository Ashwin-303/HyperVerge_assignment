variable "bucket_name" {
  type        = string
  description = "S3 bucket."
  default     = ""
}


variable "cloudfront_comment" {
  type        = string
  description = "add comment for cloudfront distribution"
  default     = "web portal"
}

variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "portal" {
  default = "web"
  type    = string
}

variable "env" {
  default = ""
  type    = string
}

variable "project_prefix" {
  default = ""
  type    = string
}

variable "cachePolicyId" {
  default = ""
  type    = string
}
# variable "enable_autoscaling" {
#   description = "If set to true, enable auto scaling"
#   type        = bool
# }
