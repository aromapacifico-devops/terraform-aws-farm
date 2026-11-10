# terraform-aws-farm

Reusable module of one Aroma Pacifico farm. The platform has no per-farm network, so a farm exists in the cloud as an identity, and this module creates that identity for one node. It repeats with no effort from 1 to 200 farms. It implements box C10 of the implementation scope.

This repository holds the skeleton and the interface the module commits to. The resources arrive with the first release, and no version tag exists yet.

## What it creates

| Resource | Purpose |
|---|---|
| IoT thing | Record of the node, with farm, department and zones as attributes |
| Group membership | Places the node in its department, for cost and operations |
| Certificate from a CSR | Identity of the node |
| Policy and thing attachments | Tie the certificate to the shared policy and to the thing |

The thing group and the IoT policy already exist when this module runs. The telemetry ingestion module creates them, because they belong to the department and to the platform, and many farms share them.

## Why a certificate signing request

Terraform can ask AWS to generate a certificate and its keys, and in that case the private key lands in the state file. The state must hold no secrets, so that option is ruled out. With a certificate signing request, the private key is created on the device and never leaves it, and Terraform receives only the public part.

## Usage

Use the latest released tag in place of `v1.0.0`.

```hcl
module "farm" {
  source = "git::https://github.com/aromapacifico-devops/terraform-aws-farm.git?ref=v1.0.0"

  providers = {
    aws.project = aws.principal
  }

  client      = var.client
  project     = var.project
  environment = var.environment

  iot_policy_name  = module.telemetry_ingestion.iot_policy_name
  thing_group_name = module.telemetry_ingestion.thing_group_names["cauca"]

  farm_id    = "f-41-0137"
  department = "cauca"
  node_id    = "node-41-00137"
  csr_pem    = var.farm_csr_pem
}
```

A thing name is unique inside an account and Region. When environments share an account, each one uses its own sample node.

## From one farm to 200

The sample proves the module with one farm. Reaching 200 means repeating the call with `for_each` over a map of nodes. Each node is provisioned before shipment, where it generates its key pair and its certificate request, so the installer runs nothing at the farm and handles no secret. Fleet provisioning with a claim was discarded, since a claim is a credential shared by every node that uses it.

## Inputs

| Name | Type | Required | Description |
|---|---|---|---|
| `client`, `project`, `environment`, `additional_tags` | Governance | See below | Codes for tags and the extra tags of the module. `additional_tags` is optional |
| `iot_policy_name` | `string` | Yes | Shared policy to attach to the certificate |
| `thing_group_name` | `string` | Yes | Thing group of the department |
| `farm_id` | `string` | Yes | Identifier of the farm |
| `department` | `string` | Yes | Department of the farm |
| `node_id` | `string` | Yes | Name of the thing, which is also the MQTT client ID |
| `csr_pem` | `string` | Yes | Certificate signing request created on the device |

## Outputs

| Name | Description |
|---|---|
| `thing_name` | Name of the thing |
| `thing_arn` | ARN of the thing |
| `certificate_arn` | ARN of the certificate |
| `certificate_pem` | Public certificate to install on the node |

## Destroying an environment

An active certificate with attachments blocks its own deletion, so the module detaches and deactivates it first. A destroy therefore leaves no identity behind.

## Cost

Things, certificates and policies have no charge. IoT Core bills connections and messages, which the telemetry ingestion path covers.

## Develop and test

The exact Terraform version lives in `.terraform-version`. Tests run against a mocked provider, so they need no AWS account and spend no credits.

```bash
terraform init -backend=false
terraform test
terraform -chdir=sample init -backend=false
terraform -chdir=sample validate
```

`terraform validate` runs on `sample/` because this module declares the `aws.project` provider alias, which only receives a provider from a caller.

The shared checks of the organization cover format, tests, TFLint, Checkov and secret scanning. An accepted finding goes in `docs/iac-exceptions.md` with its reason and its end condition.

## Versions

Commits follow Conventional Commits, and they decide the next version. A `fix` raises the patch, a `feat` raises the minor, and a breaking change raises the major. Each release publishes an exact `vX.Y.Z` tag and updates `CHANGELOG.md`. Consumers pin that tag, so a new version reaches an environment only through a reviewed change in the infrastructure repository.

## Related repositories

| Repository | Role |
|---|---|
| [`aromapacifico-devops-infra`](https://github.com/aromapacifico-devops/aromapacifico-devops-infra) | Roots of each environment, which consume this module |
| [`terraform-aws-module-template`](https://github.com/aromapacifico-devops/terraform-aws-module-template) | Template this repository was generated from |
| [`aromapacifico-devops-docs`](https://github.com/aromapacifico-devops/aromapacifico-devops-docs) | Architecture and design documents |
