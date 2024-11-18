resource "aws_dynamodb_table" "game_state" {
  name           = "${var.project_name}-game-state-${var.environment}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "gameId"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "gameId"
    type = "S"
  }

  tags = {
    Name = "${var.project_name}-game-state-${var.environment}"
  }
}

resource "aws_dynamodb_table" "game_moves" {
  name           = "${var.project_name}-game-moves-${var.environment}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "gameId"
  range_key      = "moveNumber"

  attribute {
    name = "gameId"
    type = "S"
  }

  attribute {
    name = "moveNumber"
    type = "N"
  }

  tags = {
    Name = "${var.project_name}-game-moves-${var.environment}"
  }
}
