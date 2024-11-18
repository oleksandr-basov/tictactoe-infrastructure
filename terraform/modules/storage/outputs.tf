output "game_state_table_name" {
  value       = aws_dynamodb_table.game_state.name
  description = "Name of the game state DynamoDB table"
}

output "game_state_table_arn" {
  value       = aws_dynamodb_table.game_state.arn
  description = "ARN of the game state DynamoDB table"
}

output "game_moves_table_name" {
  value       = aws_dynamodb_table.game_moves.name
  description = "Name of the game moves DynamoDB table"
}

output "game_moves_table_arn" {
  value       = aws_dynamodb_table.game_moves.arn
  description = "ARN of the game moves DynamoDB table"
}
