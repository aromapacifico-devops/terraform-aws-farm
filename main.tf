# Resources of the module. Every resource sets provider = aws.project.
resource "aws_iot_thing" "node" {
  provider = aws.project

  name = var.node_id

  attributes = {
    farm_id    = var.farm_id
    department = var.department
  }
}

resource "aws_iot_thing_group_membership" "node" {
  provider = aws.project

  thing_name       = aws_iot_thing.node.name
  thing_group_name = var.thing_group_name
}

# Signed from the request of the device, so AWS returns no private key and the state holds none.
resource "aws_iot_certificate" "node" {
  provider = aws.project

  csr    = var.csr_pem
  active = true
}

resource "aws_iot_policy_attachment" "node" {
  provider = aws.project

  policy = var.iot_policy_name
  target = aws_iot_certificate.node.arn
}

resource "aws_iot_thing_principal_attachment" "node" {
  provider = aws.project

  thing     = aws_iot_thing.node.name
  principal = aws_iot_certificate.node.arn
}
