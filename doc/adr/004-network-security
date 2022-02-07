# 4. Network Security

Date: 2022-02-06

## Status

Accepted

## Context

Building on the previous ADR documents (002 and 003), we need to ensure that security is paramount in architecting our deployment.

## Decision

- VPC is custom VPC and default will not be used
- As briefly discussed on [002](./002-provisionining-in-aws.md), there will be 6 subnets and only 2 will be public
- ALB is open to public network
- EC2 instances can only be accessed on port 3000 from ALB security group.
- RDS instances can only be accessed on port 5432 from EC2 security group.
- NACL rules are kept by default (0.0.0.0/0) due to time constraints.
- No NAT GW/NAT Instances to be provisioned
- Secrets to be seeded via user.tfvars file

## Consequences

- Custom VPC would mean deploying IGW, subnets and subnet group for all blocks = longer terraform configs.
- Both EC2 and RDS instances are not required to connect to outside internet at the moment so there shouldn't be any need to configure NAT GWs or NAT Instances. Thus a benefit for security hardening as a byproduct.
- Secrets being on user.tfvars file would be a red flag for CISSP-ers out there but for the sake of simplicity, this exercise would assume the position (also the time saving benefits outweigh the risk)