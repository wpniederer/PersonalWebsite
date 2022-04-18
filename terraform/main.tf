variable "scalr_org_id" {
  type = string
}

variable "scalr_hostname" {
  type = string
}

variable "scalr_workspace_name" {
  type    = string
  default = "PersonalWebsite Prod"
}

terraform {
  backend "remote" {
    hostname     = var.scalr_hostname
    organization = var.scalr_org_id

    workspaces {
      name = var.scalr_workspace_name
    }
  }
}
