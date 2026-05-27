variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = null
}

variable "role_arn" {
  description = "ARN of the IAM role for the Lambda function"
  type        = string
  validation {
    condition     = can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "role_arn must be a valid IAM role ARN."
  }
}

variable "handler" {
  description = "Function entrypoint (e.g., index.handler)"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Runtime identifier (e.g., nodejs20.x, python3.12, provided.al2023)"
  type        = string
  default     = "provided.al2023"
}

variable "timeout" {
  description = "Function timeout in seconds"
  type        = number
  default     = 30
  validation {
    condition     = var.timeout >= 1 && var.timeout <= 900
    error_message = "timeout must be between 1 and 900 seconds."
  }
}

variable "memory_size" {
  description = "Amount of memory in MB"
  type        = number
  default     = 128
  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "memory_size must be between 128 and 10240 MB."
  }
}

variable "filename" {
  description = "Path to the deployment package (mutually exclusive with s3_bucket/s3_key)"
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket containing the deployment package"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of the deployment package"
  type        = string
  default     = null
}

variable "architectures" {
  description = "Instruction set architecture (x86_64 or arm64)"
  type        = list(string)
  default     = ["arm64"]
}

variable "environment_variables" {
  description = "Map of environment variables for the function"
  type        = map(string)
  default     = {}
}
