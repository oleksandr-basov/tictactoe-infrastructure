variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "game_state_table_name" {
  description = "Name of the DynamoDB table for game state"
  type        = string
}

variable "game_moves_table_name" {
  description = "Name of the DynamoDB table for game moves"
  type        = string
}

variable "game_state_table_arn" {
  description = "ARN of the DynamoDB table for game state"
  type        = string
}

variable "game_moves_table_arn" {
  description = "ARN of the DynamoDB table for game moves"
  type        = string
}

variable "lambda_version" {
  description = "Version of Lambda functions to deploy"
  type        = string
}
