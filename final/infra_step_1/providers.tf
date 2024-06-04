terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4"
    }
  }
}

provider "aws" {
  alias = "app"
  profile = "app"
  region  = "us-east-1"
}
provider "aws" {
  alias = "dba"
  profile = "dba"
  region  = "us-east-1"
}
provider "aws" {
  alias = "net"
  profile = "net"
  region  = "us-east-1"
}