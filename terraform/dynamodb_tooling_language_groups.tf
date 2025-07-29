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
  "languages": {"S": "8th,abap,arm64-assembly,arturo,awk,ballerina,bash,batch,c,cairo,cfml,chapel,clojure,clojurescript,cobol,coffeescript,common-lisp,cpp,crystal,csharp,d,dart,elixir,elm,emacs-lisp,erlang,euphoria,fortran,fsharp,futhark,gdscript,gleam,go,groovy,haskell,haxe,idris,j,java,javascript,jq,julia,kotlin,lfe,lua,mips,nim,ocaml,perl5,pharo-smalltalk,phix,php,pony,powershell,prolog,purescript,pyret,python,r,racket,raku,reasonml,red,roc,ruby,rust,scala,scheme,sml,sqlite,swift,tcl,typescript,uiua,unison,vbnet,vimscript,vlang,wasm,wren,x86-64-assembly,yamlscript,zig"}
}
ITEM
}

resource "aws_dynamodb_table_item" "tooling_language_r_all" {
  table_name = aws_dynamodb_table.tooling_language_groups.name
  hash_key   = aws_dynamodb_table.tooling_language_groups.hash_key

  item = <<ITEM
{
  "group": {"S": "representers-all"},
  "languages": {"S": "c,clojure,common-lisp,cpp,crystal,csharp,elixir,elm,fsharp,go,j,java,javascript,php,python,raku,ruby,rust,typescript,wasm,wren"}
}
ITEM
}

resource "aws_dynamodb_table_item" "tooling_language_a_all" {
  table_name = aws_dynamodb_table.tooling_language_groups.name
  hash_key   = aws_dynamodb_table.tooling_language_groups.hash_key

  item = <<ITEM
{
  "group": {"S": "analyzers-all"},
  "languages": {"S": "bash,clojure,common-lisp,crystal,csharp,elixir,elm,erlang,go,java,javascript,nim,perl5,python,ruby,rust,scala,swift,typescript"}
}
ITEM
}
