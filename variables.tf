# Input variables of the module.
variable "client" {
  description = "Client code, used in names and tags."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{1,10}$", var.client))
    error_message = "client must be 1 to 10 lowercase alphanumeric characters."
  }
}

variable "project" {
  description = "Project code, used in names and tags."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{1,15}$", var.project))
    error_message = "project must be 1 to 15 lowercase alphanumeric characters."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be dev, test or prod."
  }
}

variable "additional_tags" {
  description = "Tags added to the resources of this module, on top of the provider default tags."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for key in keys(var.additional_tags) : length(trimspace(key)) > 0])
    error_message = "additional_tags keys cannot be empty."
  }
}

variable "iot_policy_name" {
  description = "Shared node policy, created by the telemetry ingestion module, attached to the certificate."
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.iot_policy_name))
    error_message = "iot_policy_name must be a valid IoT policy name."
  }
}

variable "thing_group_name" {
  description = "Thing group of the department, created by the telemetry ingestion module."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9:_-]{1,128}$", var.thing_group_name))
    error_message = "thing_group_name must be a valid thing group name."
  }
}

variable "farm_id" {
  description = "Identifier of the farm, kept as an attribute of the thing."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.,@/:#-]{1,800}$", var.farm_id))
    error_message = "farm_id must be a valid thing attribute value."
  }
}

variable "department" {
  description = "Department code of the farm, kept as an attribute of the thing."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,32}$", var.department))
    error_message = "department must be lowercase letters, digits or hyphens."
  }
}

variable "node_id" {
  description = "Name of the thing, which is also the MQTT client ID and the node in the topic."
  type        = string

  validation {
    condition     = can(regex("^node-[a-z0-9-]{1,59}$", var.node_id))
    error_message = "node_id must start with node- and use lowercase letters, digits and hyphens."
  }
}

variable "csr_pem" {
  description = "Certificate signing request created on the device. Only the public part reaches Terraform."
  type        = string

  validation {
    condition     = startswith(trimspace(var.csr_pem), "-----BEGIN CERTIFICATE REQUEST-----") && endswith(trimspace(var.csr_pem), "-----END CERTIFICATE REQUEST-----")
    error_message = "csr_pem must hold one PEM certificate signing request."
  }

  validation {
    condition     = !strcontains(var.csr_pem, "PRIVATE KEY")
    error_message = "csr_pem must not hold a private key. The key stays on the device."
  }
}
