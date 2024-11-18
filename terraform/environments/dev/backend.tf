terraform {
  backend "s3" {
    bucket         = "tictactoe-terraform-state-dev"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tictactoe-terraform-locks-dev"
    encrypt        = true
  }
}
