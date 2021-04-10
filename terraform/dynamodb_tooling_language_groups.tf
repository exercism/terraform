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
  "languages": {"S": "bash,c,cfml,clojure,common-lisp,cpp,csharp,elixir,elm,erlang,fsharp,generic,go,j,java,javascript,julia,kotlin,lua,nim,ocaml,php,prolog,python,ruby,reasonml,rust,scheme,sml,swift,tcl,typescript,vimscript,x86-64-assembly"}
}
ITEM
}

resource "aws_dynamodb_table_item" "tooling_language_r_all" {
  table_name = aws_dynamodb_table.tooling_language_groups.name
  hash_key   = aws_dynamodb_table.tooling_language_groups.hash_key

  item = <<ITEM
{
  "group": {"S": "representers-all"},
  "languages": {"S": "c,clojure,common-lisp,csharp,elixir,elm,fsharp,j,java,javascript,nim,python,ruby,rust,typescript"}
}
ITEM
}

resource "aws_dynamodb_table_item" "tooling_language_a_all" {
  table_name = aws_dynamodb_table.tooling_language_groups.name
  hash_key   = aws_dynamodb_table.tooling_language_groups.hash_key

  item = <<ITEM
{
  "group": {"S": "analyzers-all"},
  "languages": {"S": "clojure,common-lisp,csharp,elixir,elm,erlang,go,java,javascript,nim,python,ruby,rust,scala,typescript"}
}
ITEM
}
