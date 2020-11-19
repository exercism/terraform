resource "aws_dynamodb_table" "tooling_jobs" {
  name           = "tooling_jobs"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "job_status"
    type = "S"
  }
  attribute {
    name = "created_at"
    type = "N"
  }
  attribute {
    name = "submission_uuid"
    type = "S"
  }
  attribute {
    name = "type"
    type = "S"
  }

  global_secondary_index {
    name            = "job_status"
    hash_key        = "job_status"
    range_key       = "created_at"
    projection_type = "KEYS_ONLY"
    read_capacity   = 1
    write_capacity  = 1
  }

  global_secondary_index {
    name               = "submission_type"
    hash_key           = "submission_uuid"
    range_key          = "type"
    projection_type    = "INCLUDE"
    non_key_attributes = ["id", "job_status"]
    read_capacity      = 1
    write_capacity     = 1
  }
}
