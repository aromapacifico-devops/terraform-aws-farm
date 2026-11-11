# Calls the module from the parent directory, for one sample farm.
module "this" {
  source = "../"

  providers = {
    aws.project = aws.principal
  }

  client      = var.client
  project     = var.project
  environment = var.environment

  iot_policy_name  = local.iot_policy_name
  thing_group_name = local.thing_group_name

  farm_id    = var.farm_id
  department = var.department
  node_id    = var.node_id
  csr_pem    = file(var.csr_path)
}
