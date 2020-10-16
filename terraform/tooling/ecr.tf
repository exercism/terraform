# Ensure that these are also added to iam_ecr

resource "aws_ecr_repository" "ruby_test_runner" {
  name                 = "ruby-test-runner"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}

resource "aws_ecr_repository" "csharp_test_runner" {
  name                 = "csharp-test-runner"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}

resource "aws_ecr_repository" "elixir_test_runner" {
  name                 = "elixir-test-runner"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = false }
}
