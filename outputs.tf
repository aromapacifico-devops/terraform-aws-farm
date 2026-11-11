# Outputs of the module. Each one exposes a single attribute and has a description.
output "thing_name" {
  description = "Name of the thing."
  value       = aws_iot_thing.node.name
}

output "thing_arn" {
  description = "ARN of the thing."
  value       = aws_iot_thing.node.arn
}

output "certificate_arn" {
  description = "ARN of the node certificate."
  value       = aws_iot_certificate.node.arn
}

# A certificate is public. The provider marks it sensitive, which would hide it from the installer.
output "certificate_pem" {
  description = "Public certificate to install on the node."
  value       = nonsensitive(aws_iot_certificate.node.certificate_pem)
}
