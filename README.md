# Terraform scripts for Exercism

## Credentials Setup

Create a file `~/.aws/credentials`, or add the following stanza to an existing file:

```
[exercism_terraform]
aws_access_key_id = XXXXXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

## Install

Terraform is available via `brew` on Mac OS:

```bash
brew install terraform
```

[Downloads for other OS](https://www.terraform.io/downloads.html) are available.


## Setup

CD into the `terraform` directory.

Install provider plugins:

```bash
terraform init
```


## Testing Before Doing

To see what will be run, use `plan`:

```bash
terraform plan -var-file=environments/staging.tfvars
```


## Running for Real

To run things for real, and actually make changes to infrastructure:

```bash
terraform apply -var-file=environments/staging.tfvars
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
