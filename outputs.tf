output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = try(aws_lambda_function.this[0].arn, null)
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = try(aws_lambda_function.this[0].function_name, null)
}

output "invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = try(aws_lambda_function.this[0].invoke_arn, null)
}

output "qualified_arn" {
  description = "Qualified ARN of the Lambda function"
  value       = try(aws_lambda_function.this[0].qualified_arn, null)
}
