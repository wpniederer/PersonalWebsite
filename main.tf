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

variable "app_name" {
  type    = string
  default = "personal-website"
}

variable "tags" {
  type = map(string)
  default = {
    AppName = "personal-website"
  }
}

provider "aws" {
  region = "us-west-2"
}

module "tf_next" {
  source = "milliHQ/next-js/aws"

  # next_tf_dir = var.next_tf_dir
  deployment_name = var.app_name
  lambda_runtime  = "nodejs14.x"
  tags            = var.tags

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

###########
# Variables
###########

variable "custom_domain" {
  description = "Your custom domain"
  type        = string
  default     = "walt.dev"
}

# Assuming that the ZONE of your domain is already registrated in your AWS account (Route 53)
# https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/AboutHZWorkingWith.html
variable "custom_domain_zone_name" {
  description = "The Route53 zone name of the custom domain"
  type        = string
  default     = "walt.dev."
}

###########
# Locals
###########

locals {
  aliases = [var.custom_domain]
  # If you need a wildcard domain(ex: *.example.com), you can add it like this:
  # aliases = [var.custom_domain, "*.${var.custom_domain}"]
}

#######################
# Route53 Domain record
#######################

# Get the hosted zone for the custom domain
data "aws_route53_zone" "custom_domain_zone" {
  name = var.custom_domain_zone_name
}

# Create a new record in Route 53 for the domain
resource "aws_route53_record" "cloudfront_alias_domain" {
  for_each = toset(local.aliases)

  zone_id = data.aws_route53_zone.custom_domain_zone.zone_id
  name    = each.key
  type    = "A"

  alias {
    name                   = module.tf_next.cloudfront_domain_name
    zone_id                = module.tf_next.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

##########
# SSL Cert
##########

# Creates a free SSL certificate for CloudFront distribution
# For more options (e.g. multiple domains) see:
# https://registry.terraform.io/modules/terraform-aws-modules/acm/aws/
module "cloudfront_cert" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name               = var.custom_domain
  zone_id                   = data.aws_route53_zone.custom_domain_zone.zone_id
  subject_alternative_names = slice(local.aliases, 1, length(local.aliases))

  tags = {
    Name = "CloudFront ${var.custom_domain}"
  }

  # CloudFront works only with certs stored in us-east-1
  providers = {
    aws = aws.global_region
  }
}
