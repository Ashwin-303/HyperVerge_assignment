variable "bucket_name" {
  type = string
  # description = "S3 bucket."
  # default = "admin.beaconlearningapp.com"
}


variable "cloudfront_comment" {
  type = string
  # description = "add comment for cloudfront distribution"
  # default = "admin.beaconlearningapp.com"
}

variable "AWS_REGION" {
  type = string
}

variable "cachePolicyId" {
  default = ""
  type    = string
}

variable "ENV_TAG" {
  default = ""
  type    = string
}
