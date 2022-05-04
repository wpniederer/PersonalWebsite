output "cloudfront_domain_name" {
  value = module.tf_next.cloudfront_domain_name
}

output "custom_domain_name" {
  value = var.custom_domain
}
