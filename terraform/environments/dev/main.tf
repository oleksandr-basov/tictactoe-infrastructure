terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  default_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"

  default_tags {
    tags = local.default_tags
  }
}

module "networking" {
  source = "../../modules/networking"

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  project_name              = var.project_name
  environment              = var.environment
  domain_name              = var.domain_name
  root_domain_name         = var.root_domain_name
  cloudfront_domain_name   = module.frontend.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.frontend.cloudfront_hosted_zone_id
}

module "frontend" {
  source = "../../modules/frontend"

  project_name    = var.project_name
  environment     = var.environment
  domain_name     = var.domain_name
  certificate_arn = module.networking.certificate_arn
  route53_zone_id = module.networking.zone_id
}

module "storage" {
  source = "../../modules/storage"

  project_name = var.project_name
  environment  = var.environment
}

module "backend" {
  source = "../../modules/backend"

  project_name         = var.project_name
  environment          = var.environment
  domain_name         = var.domain_name

  game_state_table_name = module.storage.game_state_table_name
  game_moves_table_name = module.storage.game_moves_table_name
  game_state_table_arn  = module.storage.game_state_table_arn
  game_moves_table_arn  = module.storage.game_moves_table_arn
  lambda_version       = var.lambda_version
}

module "auth" {
  source = "../../modules/auth"

  project_name      = var.project_name
  environment       = var.environment
  domain_name      = var.domain_name
  api_execution_arn = module.backend.api_execution_arn
}

