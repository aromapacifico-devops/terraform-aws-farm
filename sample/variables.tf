# Input variables of the sample.
variable "client" {
  description = "Client code."
  type        = string
}

variable "project" {
  description = "Project code."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "region" {
  description = "AWS Region of the sample."
  type        = string
}

variable "deploy_role_arn" {
  description = "Role to assume. Leave empty to use the local credentials."
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Tags applied to every resource through the provider."
  type        = map(string)
}

variable "farm_id" {
  description = "Identifier of the sample farm."
  type        = string
}

variable "department" {
  description = "Department of the sample farm."
  type        = string
}

variable "node_id" {
  description = "Node of the sample farm. Use one per environment, since environments share the thing registry."
  type        = string
}

variable "csr_path" {
  description = "Path of the certificate signing request made on the node."
  type        = string
}
