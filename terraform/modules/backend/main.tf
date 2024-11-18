# API Gateway
resource "aws_apigatewayv2_api" "main" {
  name          = "${var.project_name}-api-${var.environment}"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["https://${var.domain_name}"]
    allow_methods = ["GET", "POST", "PUT", "DELETE"]
    allow_headers = ["Content-Type", "Authorization"]
    max_age      = 300
  }
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = var.environment
  auto_deploy = true
}

# Lambda Functions
resource "aws_lambda_function" "create_game" {
  function_name    = "${var.project_name}-create-game-${var.environment}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "dev.basov.handler.CreateGameHandler::handleRequest"
  runtime         = "java17"
  memory_size     = 512
  timeout         = 30

  s3_bucket         = aws_s3_bucket.lambda_artifacts.id
  s3_key            = "lambda/${var.environment}/create-game-${var.lambda_version}.jar"

  environment {
    variables = {
      GAME_STATE_TABLE = var.game_state_table_name
      GAME_MOVES_TABLE = var.game_moves_table_name
    }
  }
}

resource "aws_lambda_function" "make_move" {
  function_name    = "${var.project_name}-make-move-${var.environment}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "dev.basov.handler.MakeMoveHandler::handleRequest"
  runtime         = "java17"
  memory_size     = 512
  timeout         = 30

  s3_bucket         = aws_s3_bucket.lambda_artifacts.id
  s3_key            = "lambda/${var.environment}/make-move-${var.lambda_version}.jar"

  environment {
    variables = {
      GAME_STATE_TABLE = var.game_state_table_name
      GAME_MOVES_TABLE = var.game_moves_table_name
    }
  }
}

resource "aws_lambda_function" "get_game" {
  function_name    = "${var.project_name}-get-game-${var.environment}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "dev.basov.handler.GetGameHandler::handleRequest"
  runtime         = "java17"
  memory_size     = 512
  timeout         = 30

  s3_bucket         = aws_s3_bucket.lambda_artifacts.id
  s3_key            = "lambda/${var.environment}/get-game-${var.lambda_version}.jar"

  environment {
    variables = {
      GAME_STATE_TABLE = var.game_state_table_name
      GAME_MOVES_TABLE = var.game_moves_table_name
    }
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role-${var.environment}"
  force_detach_policies = true

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# S3 bucket for Lambda artifacts
resource "aws_s3_bucket" "lambda_artifacts" {
  bucket = "${var.project_name}-lambda-artifacts-${var.environment}"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "lambda_artifacts" {
  bucket = aws_s3_bucket.lambda_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "lambda_artifacts" {
  bucket = aws_s3_bucket.lambda_artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_artifacts" {
  bucket = aws_s3_bucket.lambda_artifacts.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# IAM Policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.project_name}-lambda-policy-${var.environment}"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query"
        ]
        Resource = [
          var.game_state_table_arn,
          var.game_moves_table_arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["arn:aws:logs:*:*:*"]
      }
    ]
  })
}

# API Gateway Integrations
resource "aws_apigatewayv2_integration" "create_game" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.create_game.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_integration" "make_move" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.make_move.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_integration" "get_game" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.get_game.invoke_arn
  integration_method = "POST"
}

# API Gateway Routes
resource "aws_apigatewayv2_route" "create_game" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /games"
  target    = "integrations/${aws_apigatewayv2_integration.create_game.id}"
}

resource "aws_apigatewayv2_route" "make_move" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /games/{gameId}/moves"
  target    = "integrations/${aws_apigatewayv2_integration.make_move.id}"
}

resource "aws_apigatewayv2_route" "get_game" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /games/{gameId}"
  target    = "integrations/${aws_apigatewayv2_integration.get_game.id}"
}

# Lambda permissions for API Gateway
resource "aws_lambda_permission" "create_game" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_game.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "make_move" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.make_move.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "get_game" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_game.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}
