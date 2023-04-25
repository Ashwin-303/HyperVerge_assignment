# Variables for AWS infrastructure module

// TODO - use null defaults

# Required
# variable "aws_access_key" {
#   type        = string
#   description = "AWS access key used to create infrastructure"
# }

# # Required
# variable "aws_secret_key" {
#   type        = string
#   description = "AWS secret key used to create AWS infrastructure"
# }

variable "aws_session_token" {
  type        = string
  description = "AWS session token used to create AWS infrastructure"
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  # default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
  # default     = ""
}

variable "public_subnets" {
  type        = list(any)
  description = "public_subnet list id"
  # default     = ""
}

variable "relative_path" {
  type        = string
  description = "relative path"
  # default     = ""
}

# variable "aws_zone_a" {
#   type        = string
#   description = "AWS zone used for all resources us-east-1a"
#   default     = ""
# }

variable "aws_zone_b" {
  type        = string
  description = "AWS zone used for all resources us-east-1b"
  default     = ""
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "quickstart"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3a.medium"
}

variable "rancher_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for Rancher server cluster"
  default     = "v1.23.14+rke2r1"
}

variable "workload_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for managed workload cluster"
  default     = "v1.24.10+rke2r1"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.11.0"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format: v0.0.0)"
  default     = "2.7.1"
}

# Required
variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap, min. 12 characters"
}

# Local variables used to reduce repetition
locals {
  node_username = "ec2-user"
}

variable "name" {
  type        = string
  default     = "test"
  description = "Name for deployment"
}

variable "rancher2_custom_tags" {
  type = map(any)
  default = {
    DoNotDelete = "true"
    Owner       = "EIO_Demo"
  }
  description = "Custom tags for Rancher resources"
}

variable "domain" {
  type    = string
  default = "internal.mindbowser.com"
}

variable "r53_domain" {
  type        = string
  default     = "internal.mindbowser.com"
  description = "DNS domain for Route53 zone (defaults to domain if unset)"
}
