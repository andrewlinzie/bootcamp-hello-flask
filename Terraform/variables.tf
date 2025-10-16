variable "project_name" {
  description = "A short name used to tag/name resources"
  type        = string
  default     = "bootcamp-project"
}

variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "az_count" {
  description = "How many AZs to span"
  type        = number
  default     = 2
}

variable "key_name" {
  description = "Name of your existing EC2 key pair for SSH"
  type        = string
}
