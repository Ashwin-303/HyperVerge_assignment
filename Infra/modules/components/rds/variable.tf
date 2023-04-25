variable "rds" {
  type = object({
    allocated_storage = number
    engine            = string
    engine_version    = string
    instance_class    = string
    name              = string
  })
}

variable "identifier" {
  type = string
}

variable "rds_username" {
  type = string
}
variable "rds_password" {
  type      = string
  sensitive = true
}
variable "vpc_id" {
  type = string
}

variable "project_prefix" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "database_subnets" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "env" {
  type = string
}


variable "aws_private_subnet_ids" {
  type    = list(string)
  default = []
}

variable "aws_public_subnet_ids" {
  type    = list(string)
  default = []
}
