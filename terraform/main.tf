variable "aws_region" {
  type    = string
  default = "us-west-2"
}

terraform {
  backend "remote" {
    hostname     = "wpniederer.scalr.io"
    organization = "env-u0grbkhnofp78lo"

    workspaces {
      name = "CLI"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
