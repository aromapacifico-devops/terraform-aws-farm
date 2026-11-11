# Sample values. No identifiers of real resources and no secrets.
client      = "fnc"
project     = "aroma"
environment = "dev"
region      = "us-east-1"

common_tags = {
  Client      = "fnc"
  Project     = "aroma"
  Environment = "dev"
  Owner       = "platform"
  CostCenter  = "pruebas"
  ManagedBy   = "Terraform"
}

farm_id    = "farm-sample-0001"
department = "cauca"
node_id    = "node-sample-00001"

# Public request of a test key pair. The private key never enters the repository.
csr_path = "../tests/fixtures/node.csr"
