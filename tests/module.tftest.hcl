# Plan-time tests against a mocked provider. They need no AWS account.
mock_provider "aws" {
  alias = "project"

  override_resource {
    target          = aws_iot_certificate.node
    override_during = plan
    values          = { arn = "arn:aws:iot:us-east-1:111122223333:cert/sample" }
  }
}

variables {
  client      = "fnc"
  project     = "aroma"
  environment = "test"

  iot_policy_name  = "fnc-aroma-test-iotpol-node"
  thing_group_name = "fnc-aroma-test-thg-cauca"
  farm_id          = "farm-test-0001"
  department       = "cauca"
  node_id          = "node-test-00001"
  csr_pem          = file("tests/fixtures/node.csr")
}

run "creates_the_identity_of_one_node" {
  command = plan

  providers = {
    aws.project = aws.project
  }

  assert {
    condition     = aws_iot_thing.node.name == "node-test-00001" && aws_iot_thing.node.attributes["farm_id"] == "farm-test-0001" && aws_iot_thing.node.attributes["department"] == "cauca"
    error_message = "The thing carries the node name and the farm and department attributes."
  }

  assert {
    condition     = aws_iot_thing_group_membership.node.thing_group_name == "fnc-aroma-test-thg-cauca"
    error_message = "The node joins the group of its department."
  }

  assert {
    condition     = aws_iot_policy_attachment.node.policy == "fnc-aroma-test-iotpol-node" && aws_iot_policy_attachment.node.target == aws_iot_certificate.node.arn
    error_message = "The shared policy is attached to the certificate."
  }

  assert {
    condition     = aws_iot_thing_principal_attachment.node.principal == aws_iot_certificate.node.arn
    error_message = "The certificate is attached to the thing."
  }
}

run "signs_the_request_of_the_device" {
  command = plan

  providers = {
    aws.project = aws.project
  }

  assert {
    condition     = aws_iot_certificate.node.csr == var.csr_pem && aws_iot_certificate.node.active
    error_message = "The certificate comes from the request of the device, so AWS generates no key."
  }
}

run "rejects_a_private_key" {
  command = plan

  providers = {
    aws.project = aws.project
  }

  variables {
    csr_pem = "-----BEGIN CERTIFICATE REQUEST-----\n-----BEGIN PRIVATE KEY-----\n-----END CERTIFICATE REQUEST-----"
  }

  expect_failures = [var.csr_pem]
}

run "rejects_something_that_is_no_request" {
  command = plan

  providers = {
    aws.project = aws.project
  }

  variables {
    csr_pem = "not a request"
  }

  expect_failures = [var.csr_pem]
}

run "rejects_a_node_name_outside_the_convention" {
  command = plan

  providers = {
    aws.project = aws.project
  }

  variables {
    node_id = "Node 1"
  }

  expect_failures = [var.node_id]
}

run "rejects_an_unknown_environment" {
  command = plan

  providers = {
    aws.project = aws.project
  }

  variables {
    environment = "staging"
  }

  expect_failures = [var.environment]
}
