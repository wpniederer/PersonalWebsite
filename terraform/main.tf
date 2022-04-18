variable "org_id" {
  type = string
}

terraform {
  backend "remote" {
    hostname     = "wpniederer.scalr.io"
    organization = var.org_id

    workspaces {
      name = "PersonalWebsite"
    }
  }
}
