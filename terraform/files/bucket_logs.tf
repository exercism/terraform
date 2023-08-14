resource "aws_s3_bucket" "ops_bucket" {
  bucket = var.bucket_logs_name
}

resource "aws_s3_bucket_acl" "ops_bucket" {
  bucket = aws_s3_bucket.ops_bucket.id
  # acl    = "private"

  access_control_policy {
    owner {
      id = data.aws_canonical_user_id.current.id
    }
    grant {
      grantee {
        id   = "805e8c1de25caf448b025bc22d8940cdedcc85bb3bfee196cf235a12d39cd4e6"
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }
    grant {
      permission = "FULL_CONTROL"
      grantee {
        id   = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
        type = "CanonicalUser"
      }
    }
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "ops_bucket" {
  bucket = aws_s3_bucket.ops_bucket.id


  rule {
    bucket_key_enabled = false

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}
