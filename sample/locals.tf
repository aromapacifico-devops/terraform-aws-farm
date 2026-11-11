# Transformations of the sample. The names of the shared policy and group follow the convention of the
# telemetry ingestion module, which must already be deployed in the same environment.
locals {
  name_prefix      = "${var.client}-${var.project}-${var.environment}"
  iot_policy_name  = "${local.name_prefix}-iotpol-node"
  thing_group_name = "${local.name_prefix}-thg-${var.department}"
}
