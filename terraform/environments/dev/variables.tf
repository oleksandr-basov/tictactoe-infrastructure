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

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "game.basov.dev"
}

variable "root_domain_name" {
  description = "Root domain name"
  type        = string
  default     = "basov.dev"
}

variable "lambda_version" {
  description = "Lambda version"
  type        = string
  default     = "latest"
}
