resource "aws_lambda_function" "this" {
  count = module.this.enabled ? 1 : 0

  function_name = module.this.id
  description   = coalesce(var.description, "Lambda: ${module.this.id}")
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size
  filename      = var.filename
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  architectures = var.architectures

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  tags = local.tags
}
