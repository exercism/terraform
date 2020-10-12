# Terraform scripts for Exercism

## Install

Terraform is available via `brew` on Mac OS:

```bash
brew install terraform
```

[Downloads for other OS](https://www.terraform.io/downloads.html) are available.

## AWS Setup

### Create state bucket

Terraform state is stored in s3.

Create a bucket with Bucket Versioning enabled.
The default bucket is currently `exercism-staging-terraform` - update `terraform/terraform.tf` if you want to change this.

Create a policy called `terraform-s3-state` with the following JSON:
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::mybucket"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::exercism-terraform/pre-production.state"
    }
  ]
}
```


Create a policy called `terraform-iam` with the following JSON:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1469200763880",
            "Action": [
                "iam:AttachRolePolicy",
                "iam:CreateRole",
                "iam:GetRole",
                "iam:ListInstanceProfilesForRole",
                "iam:DeleteRole",
                "iam:PutRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:PassRole",
                "iam:ListAttachedRolePolicies",
                "iam:UpdateAssumeRolePolicy",
                "iam:DetachRolePolicy",
                "iam:GetServiceLinkedRoleDeletionStatus",
                "iam:CreatePolicy",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:ListPolicyVersions",
                "iam:DeletePolicy"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```

- Create a terraform IAM user.
- Give them PowerUser privileges and the above policies.
- Set programatic access and save the keys for later.

### Create a deploy user

- Create an IAM user called `github-deploy`
- Give them no permissions (these will be set by terraform)
- Set programatic access and save the keys for later.

## Setup

CD into the `terraform` directory.

Install provider plugins:

```bash
terraform init
```

## Credentials Setup

Create a file `~/.aws/credentials`, or add the following stanza to an existing file with terraform user's credentials.

```
[exercism_terraform]
aws_access_key_id = XXXXXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

## Init

Start by running `terraform init`.

```
AWS_PROFILE=exercism_terraform terraform init
```

## Testing Before Doing

To see what will be run, use `plan`:

```bash
AWS_PROFILE=exercism_terraform terraform plan -var-file=variables/pre-production.tfvars
```


## Running for Real

To run things for real, and actually make changes to infrastructure:

```bash
AWS_PROFILE=exercism_terraform terraform apply -var-file=environments/staging.tfvars
```

## Debugging

The environment variable `TF_LOG` can be set to `DEBUG` or another value to enable more versbose logs.

For all values see the [Terraform debugging documenteion](https://www.terraform.io/docs/internals/debugging.html)

## Formatting

Terraform provides a tool to format manifests:

```
terraform fmt
```

## More Documentation

- [Getting started blog post](https://hackernoon.com/introduction-to-aws-with-terraform-7a8daf261dc0) which describes basic usage, templates, and variables.
- [Terraform documentation](https://www.terraform.io/docs/index.html)
- [S3 Bucket provider documentation](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html)

- [Public + Private VPC](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html#VPC_Scenario2_Implementation)
- [Useful Fargate Blog Post] (https://blog.oxalide.io/post/aws-fargate/)
