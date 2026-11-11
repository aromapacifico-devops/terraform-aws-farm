# Outputs that prove the sample worked.
output "thing_name" {
  description = "Thing of the sample node."
  value       = module.this.thing_name
}

output "certificate_arn" {
  description = "Certificate of the sample node."
  value       = module.this.certificate_arn
}
