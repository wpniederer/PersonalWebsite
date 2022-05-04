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
      version = "~> 4.0"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "tag" {
  type = string
}

provider "aws" {
  region = "us-west-2"
}

module "tf_next" {
  source = "milliHQ/next-js/aws"

  # next_tf_dir = var.next_tf_dir

  providers = {
    aws.global_region = aws.global_region
  }
}

##### tf_next Vars #####

provider "aws" {
  alias  = "global_region"
  region = "us-east-1"
}



variable "next_tf_dir" {
  type    = string
  default = "../.next-tf"

}
