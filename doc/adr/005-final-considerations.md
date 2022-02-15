# 5. Final Considerations

Date: 2022-02-06

## Status

Accepted

## Context

Final considerations prior to submission, for further exploratory work should time/cost permit.

## Decision

- Scaling between App <-> DB: Decoupling messages between app block and db block with message queues

- DB access can be done via IAM roles instead.

- Passwords can be kept and rotated with Secrets Manager.

- Tightening security with NACL rules (allow ephemeral ports only, setting in line with security groups, etc) and enabling CloudTrail for DB access.

- Serving DB and initialising it can be done with Systems Manager or Lambda functions.

- REST APIs can be configured for end users to interact with the application tier. 

- Monitoring with cloudwatch OR *Splunk*. 

## Consequences

- Even more complicated deployment 

- At this stage CI/CD has to be implemented, which would be out of scope of this project. (Jenkins would be a nice tool that I'm kinda familiar with)

- More tools = more $$$.