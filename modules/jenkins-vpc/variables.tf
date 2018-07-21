variable "aws_region" {
  description = "AWS region"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "frontend_cidr_az1" {
  description = "Frontend subnet CIDR block in AZ1"
  default     = "10.0.1.0/24"
}

variable "frontend_cidr_az2" {
  description = "Frontend subnet CIDR block in AZ1"
  default     = "10.0.2.0/24"
}
