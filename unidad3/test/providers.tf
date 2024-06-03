terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4"
    }
  }
}

provider "aws" {
  alias = "l1group"
  profile = "l1group"
  region  = "us-east-1"
}

provider "aws" {
  alias = "l2group"
  profile = "l2group"
  region  = "us-east-1"
}
provider "aws" {
  alias = "l3group"
  profile = "l3group"
  region  = "us-east-1"
}