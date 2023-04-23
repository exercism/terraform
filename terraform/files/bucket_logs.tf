resource "aws_s3_bucket" "ops_bucket" {
  bucket = var.bucket_logs_name
  grant {
    id = "805e8c1de25caf448b025bc22d8940cdedcc85bb3bfee196cf235a12d39cd4e6"
    permissions = [
      "FULL_CONTROL",
    ]
    type = "CanonicalUser"
  }
  grant {
    id = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
    permissions = [
      "FULL_CONTROL",
    ]
    type = "CanonicalUser"
  }
  
  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}
