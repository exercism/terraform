resource "aws_dynamodb_table" "tooling_language_groups" {
  name           = "tooling_language_groups"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "group"

  attribute {
    name = "group"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "tooling_language_tr_all" {
  table_name = aws_dynamodb_table.tooling_language_groups.name
  hash_key   = aws_dynamodb_table.tooling_language_groups.hash_key

  item = <<ITEM
{
  "group": {"S": "test-runners-all"},
  "languages": {"S": "ruby,csharp,elixir,javascript,julia"}
}
ITEM
}

