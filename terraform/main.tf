variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "env" {
  type    = string
  default = "prod"
}


variable "artifact_bucket" {
  type    = string
  default = "walters-playground-build-artifacts"
}

variable "tag" {
  type = string
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
