output "api_execution_arn" {
  value       = aws_apigatewayv2_api.main.execution_arn
  description = "API Gateway execution ARN"
}
output "api_endpoint" {
  value       = "${aws_apigatewayv2_api.main.api_endpoint}/${aws_apigatewayv2_stage.main.name}"
  description = "API Gateway endpoint URL"
}

output "create_game_function_name" {
  value       = aws_lambda_function.create_game.function_name
  description = "Name of the create game Lambda function"
}

output "make_move_function_name" {
  value       = aws_lambda_function.make_move.function_name
  description = "Name of the make move Lambda function"
}

output "get_game_function_name" {
  value       = aws_lambda_function.get_game.function_name
  description = "Name of the get game Lambda function"
}
