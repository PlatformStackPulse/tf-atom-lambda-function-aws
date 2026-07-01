# Unit Tests for tf-atom-lambda-function-aws
#
# These tests use a mock AWS provider — no real AWS calls are made (plan-only).
# Run with:         terraform test
# Run verbose:      terraform test -verbose
# Run specific:     terraform test -run "creates_when_enabled"

mock_provider "aws" {}

variables {
  # tf-label identity
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # Module-specific required input
  role_arn = "arn:aws:iam::123456789012:role/eg-test-thing-exec"

  # Deployment package source (aws_lambda_function requires one of
  # filename / image_uri / s3_bucket) — use S3 for the plan.
  s3_bucket = "eg-test-artifacts"
  s3_key    = "thing/bootstrap.zip"

  # Optional inputs given explicit sample values for a realistic plan
  handler       = "bootstrap"
  runtime       = "provided.al2023"
  timeout       = 30
  memory_size   = 256
  architectures = ["arm64"]
  environment_variables = {
    LOG_LEVEL = "info"
  }
}

# ---------------------------------------------------------------------------
# Test: module creates the Lambda function when enabled (default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true by default"
  }

  assert {
    condition     = aws_lambda_function.this[0].function_name == module.this.id
    error_message = "Lambda function_name should equal the tf-label id"
  }

  assert {
    condition     = aws_lambda_function.this[0].role == "arn:aws:iam::123456789012:role/eg-test-thing-exec"
    error_message = "Lambda role should be the provided role_arn"
  }
}

# ---------------------------------------------------------------------------
# Test: module creates nothing when disabled
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.function_arn == null
    error_message = "function_arn should be null when the module is disabled"
  }

  assert {
    condition     = length(aws_lambda_function.this) == 0
    error_message = "No Lambda function should be planned when disabled"
  }
}
