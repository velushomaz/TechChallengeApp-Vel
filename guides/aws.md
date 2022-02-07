# AWS IAM Permissions for Terraform

## Rationale

Since Terraform would need permissions to do CRUD operations on AWS instances.

## My Preferred Method

- Create a custom IAM policy. I am using a strict policy provided by Linux Academy I previously used when I was studying about Terraform.
You can find it [here](https://raw.githubusercontent.com/linuxacademy/content-deploying-to-aws-ansible-terraform/master/iam_policies/terraform_deployment_iam_policy.json)
[AWS Docs on Creating Policy and Attaching it to user here](https://raw.githubusercontent.com/linuxacademy/content-deploying-to-aws-ansible-terraform/master/iam_policies/terraform_deployment_iam_policy.json)

- Attach the role to a new user, then create AWS Acces Key and Secret with it. Seed it on your user.tfvars file.
