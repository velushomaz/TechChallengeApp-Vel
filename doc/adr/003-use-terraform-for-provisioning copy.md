# 3. Use Terraform for Provisioning

Date: 2022-02-06

## Status

Accepted

## Context

Building on the previous ADR document [002-provisionining-in-aws.md](./002-provisionining-in-aws.md), we need to ensure that we can deploy to AWS as swiftly and efficiently as possible, as time to deploy is of an essence.

Requirements: Challenge has to be done within 2 hours tops! 

## Decision

Terraform is selected as our tool of choice.

- TF files will be named by component

- user.tfvars file has to be provided since password and secrets is applied in plaintext, 

- terraform.tfvars file contains architecture-related settings (subnet, instance types)

## Consequences

(+) Simple deployments will be simpler to deploy 
(+) Ability to destroy stacks cleanly* with TF if not required 
(+) Reduces deployment time from hours/days to minutes.
(+) Formatting tf files is easy with terraform fmt command.
(-) Consequently, more complicated deployments will mean more files 