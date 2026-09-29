# terraform-aws-inspector2-enabler

Terraform module enabling Amazon Inspector in one or more accounts and
selecting what it scans.

## Cost

Inspector is billed per resource scanned per month, and each resource type
is billed at its own rate: EC2 instances, container images pushed to ECR,
Lambda functions, and Lambda code scanned statically. Enabling a type adds
every matching resource in the account to the bill, so the cost follows the
size of the estate rather than the number of findings.

`LAMBDA` covers dependency vulnerabilities in a function's packages.
`LAMBDA_CODE` adds static analysis of the function source and is billed on
top of it, which is why the default set stops at `LAMBDA`. See AWS's
[Inspector pricing](https://aws.amazon.com/inspector/pricing/) page for
current rates.

## Design

Left unset, `account_ids` resolves to the calling account, so the common
single-account case needs no input at all. Any other account listed must
already be a member of the Inspector organization, or the apply fails.

### Tagging

The `aws_inspector2_enabler` resource accepts no tags, so this module takes
no `tags` variable. A consumer wanting account-wide tagging should set
`default_tags` on the provider.

## Usage

```hcl
module "inspector" {
  source = "kn47ytv9mv/inspector2-enabler/aws"
}
```

Or directly from this repository:

```hcl
module "inspector" {
  source = "github.com/kn47ytv9mv/terraform-aws-inspector2-enabler"
}
```

Scanning Lambda source as well as its dependencies:

```hcl
module "inspector" {
  source = "kn47ytv9mv/inspector2-enabler/aws"

  resource_types = ["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]
}
```

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.2 |
| aws | ~> 6.61 |

## Providers

| Name | Version |
|---|---|
| aws | ~> 6.61 |

## Inputs

| Name | Description | Default | Required |
|---|---|---|---|
| account_ids | Accounts to enable Amazon Inspector in. Left null, this account. | `null` | no |
| resource_types | What Inspector scans (e.g. `'EC2'`, `'ECR'`, `'LAMBDA'`, `'LAMBDA_CODE'`, `'CODE_REPOSITORY'`). | `["EC2", "ECR", "LAMBDA"]` | no |

## Outputs

| Name | Description |
|---|---|
| account_ids | The accounts Inspector was enabled in. |
| resource_types | The resource types Inspector is scanning. |

## License

MIT — see [LICENSE.md](LICENSE.md).
