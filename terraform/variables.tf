variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "tictactoe"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
