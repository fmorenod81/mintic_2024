variable "aws_region" {
  default = "us-east-1"
}


#variable "private_key_path" {}

variable "environment" {
  default = "final-FJMD"
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

variable "private_subnets_cidr" {
  type        = list(any)
  default     = ["172.16.20.0/24", "172.16.30.0/24"]
  description = "CIDR block for Private Subnet"
}

variable "private_subnets_ports" {
  type        = list(any)
  default     = ["3306", "5432"]
  description = "Opened Ports from Public Subnets to these ports"
}

variable "public_subnets_ports" {
  type        = list(any)
  default     = ["80", "22"]
  description = "Opened Ports from Internet to these ports"
}
variable "name_of_keypair" {
  type = string
  default = "FJMDBootcampFinal"
}