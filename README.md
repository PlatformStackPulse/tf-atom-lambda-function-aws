# tf-atom-lambda-function-aws

> Terraform atom: a single AWS Lambda function with tf-label naming/tagging.

[![CI](https://github.com/PlatformStackPulse/tf-atom-lambda-function-aws/actions/workflows/ci.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-lambda-function-aws/actions/workflows/ci.yml)
[![Latest Release](https://img.shields.io/github/v/release/PlatformStackPulse/tf-atom-lambda-function-aws)](https://github.com/PlatformStackPulse/tf-atom-lambda-function-aws/releases)
![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.6.0-blueviolet)

---

Terraform atom that provisions a single AWS Lambda function, with tf-label naming/tagging and a togglable `enabled` switch.

## Features

- Creates one `aws_lambda_function` named and tagged from the tf-label context (`namespace`/`stage`/`name` → `module.this.id`).
- Deploy from a local package (`filename`) or from S3 (`s3_bucket` + `s3_key`).
- Configurable `handler`, `runtime` (defaults to `provided.al2023`), `timeout`, and `memory_size`, each with input validation.
- Selectable CPU `architectures` (defaults to `["arm64"]`).
- Optional environment variables via `environment_variables` (block is omitted when empty).
- `enabled = false` provisions nothing (count-gated), so the module is safe to include and toggle per environment.
- Exposes `function_arn`, `function_name`, `invoke_arn`, and `qualified_arn` outputs for wiring into API Gateway, EventBridge, or permissions.

## Usage

```hcl
module "lambda" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-lambda-function-aws.git?ref=v1.0.0"

  namespace = "eg"
  stage     = "prod"
  name      = "api"

  role_arn = aws_iam_role.lambda_exec.arn

  handler       = "bootstrap"
  runtime       = "provided.al2023"
  timeout       = 30
  memory_size   = 256
  architectures = ["arm64"]

  s3_bucket = "eg-prod-artifacts"
  s3_key    = "api/bootstrap.zip"

  environment_variables = {
    LOG_LEVEL = "info"
  }
}
```

## Module Documentation

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | git::https://github.com/PlatformStackPulse/tf-label.git | v1.0.0 |

### Resources

| Name | Type |
|------|------|
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | ARN of the IAM role for the Lambda function | `string` | n/a | yes |
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture (x86\_64 or arm64) | `list(string)` | <pre>[<br/>  "arm64"<br/>]</pre> | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes and tags, which are merged. | <pre>object({<br/>    enabled             = optional(bool, true)<br/>    namespace           = optional(string, null)<br/>    tenant              = optional(string, null)<br/>    environment         = optional(string, null)<br/>    stage               = optional(string, null)<br/>    name                = optional(string, null)<br/>    delimiter           = optional(string, null)<br/>    attributes          = optional(list(string), [])<br/>    tags                = optional(map(string), {})<br/>    label_order         = optional(list(string), null)<br/>    regex_replace_chars = optional(string, null)<br/>    id_length_limit     = optional(number, null)<br/>    label_key_case      = optional(string, null)<br/>    label_value_case    = optional(string, null)<br/>    labels_as_tags      = optional(set(string), null)<br/>    descriptor_formats = optional(map(object({<br/>      format = string<br/>      labels = list(string)<br/>    })), {})<br/>  })</pre> | `{}` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Lambda function | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | <pre>map(object({<br/>    format = string<br/>    labels = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources. | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'. | `string` | `null` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Map of environment variables for the function | `map(string)` | `{}` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | Path to the deployment package (mutually exclusive with s3\_bucket/s3\_key) | `string` | `null` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Function entrypoint (e.g., index.handler) | `string` | `"index.handler"` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` to keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>Note: The value of the `name` tag, if included, will be the `id`, not the `name`. | `set(string)` | `null` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB | `number` | `128` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique. | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime identifier (e.g., nodejs20.x, python3.12, provided.al2023) | `string` | `"provided.al2023"` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | S3 bucket containing the deployment package | `string` | `null` | no |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | S3 key of the deployment package | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element. A customer identifier, indicating who this instance of a resource is for. | `string` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Function timeout in seconds | `number` | `30` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether the module is enabled |
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | ARN of the Lambda function |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the Lambda function |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | Invoke ARN of the Lambda function |
| <a name="output_qualified_arn"></a> [qualified\_arn](#output\_qualified\_arn) | Qualified ARN of the Lambda function |
<!-- END_TF_DOCS -->

## Tests

Unit tests live in `tests/unit/` and run plan-only against a mock AWS provider (no real AWS calls, no credentials required):

```bash
terraform init -backend=false && terraform test -test-directory=tests/unit
```

Or via the Makefile: `make test-unit`.

