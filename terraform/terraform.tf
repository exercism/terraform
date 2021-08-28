terraform {
  backend "s3" {
    bucket = "exercism-terraform"
    key    = "production.state"
    region = "eu-west-2"
  }
}
