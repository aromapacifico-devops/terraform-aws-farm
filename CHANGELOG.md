# Changelog

## [Unreleased]

### Added

- Identity of one farm node. IoT thing with farm and department attributes, membership in the department group, certificate signed from a request made on the device, and attachments of the shared policy and of the thing.
- Inputs `iot_policy_name`, `thing_group_name`, `farm_id`, `department`, `node_id` and `csr_pem`, and outputs `thing_name`, `thing_arn`, `certificate_arn` and `certificate_pem`.
