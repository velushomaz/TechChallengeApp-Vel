# 2. Provisioning in AWS

Date: 2022-02-06

## Status

Accepted

## Context

It is necessary to select the proper cloud provider considering these key aspects:

- Cost 

- Time to deployment

- Familiarity

- Supportability

## Decision

AWS is chosen as the deployment IaaS/PaaS provider of choice.

There will be:
- Region: ap-southeast-2 (for latency).

- 6 subnets: 2 public, 2 private (EC2), 2 private (RDS) spanning 2 AZ.

- Consequently, the stack will comprise of ALB block on public subnet, App block on the EC2 private subnet, DB block on RDS private subnet

- EC2 Auto Scaling Group is used over Kubernetes/Docker or even serverless due to familiarity (working on CKA cert this month!)

## Consequences

- Cost: $$$ if not on free tier. Since ap-southeast-2 is chosen due to latency, I have to apply and destroy to ensure cost effective measures.

- Time to deployment: Constructing each component one by one is lengthy

- Familiarity: I've just passed my AWS SAA cert so that would be excellent to demonstrate my learning

- Supportability: Very easy, there are friends and colleagues I can ask about and plethora of resources on the internet