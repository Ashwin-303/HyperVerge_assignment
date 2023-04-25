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

variable "image_id" {
  type        = string
  description = "image id"
  # default     = ""
}

variable "instance_type" {
  type        = string
  description = "instance_type"
  # default     = ""
}

variable "key_name" {
  type        = string
  description = "key_name"
  # default     = ""
}