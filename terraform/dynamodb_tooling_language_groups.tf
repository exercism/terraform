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
  "languages": {"S": "abap,awk,bash,c,cobol,cfml,clojure,clojurescript,crystal,coffeescript,common-lisp,cpp,csharp,d,dart,elixir,elm,emacs-lisp,erlang,fortran,fsharp,go,groovy,haskell,haxe,j,java,javascript,julia,kotlin,lfe,lua,mips,nim,ocaml,perl5,php,prolog,purescript,python,r,racket,raku,red,ruby,reasonml,rust,scala,scheme,sml,swift,tcl,typescript,unison,vbnet,vimscript,wasm,wren,x86-64-assembly"}
}
ITEM
}

resource "aws_dynamodb_table_item" "tooling_language_r_all" {
  table_name = aws_dynamodb_table.tooling_language_groups.name
  hash_key   = aws_dynamodb_table.tooling_language_groups.hash_key

  item = <<ITEM
{
  "group": {"S": "representers-all"},
  "languages": {"S": "c,clojure,common-lisp,csharp,elixir,elm,fsharp,j,java,javascript,python,ruby,rust,typescript,wren"}
}
ITEM
}

resource "aws_dynamodb_table_item" "tooling_language_a_all" {
  table_name = aws_dynamodb_table.tooling_language_groups.name
  hash_key   = aws_dynamodb_table.tooling_language_groups.hash_key

  item = <<ITEM
{
  "group": {"S": "analyzers-all"},
  "languages": {"S": "bash,clojure,common-lisp,csharp,elixir,elm,erlang,go,java,javascript,nim,python,ruby,rust,scala,typescript"}
}
ITEM
}
