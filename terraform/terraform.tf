terraform {
  backend "s3" {
    bucket = "exercism-staging-terraform"
    key    = "pre-production.state"
    region = "eu-west-2"
  }
}
