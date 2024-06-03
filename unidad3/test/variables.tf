variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  default = "FJMD"
}

variable "vpc_cidr" {
  default     = "172.16.0.0/16"
  description = "CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list(any)
  default     = ["172.16.0.0/24", "172.16.10.0/24"]
  description = "CIDR block for Public Subnet"
}

variable "public_subnets_ports" {
  type        = list(any)
  default     = ["80", "8080", "22"]
  description = "Opened Ports from Internet to these ports"
}
