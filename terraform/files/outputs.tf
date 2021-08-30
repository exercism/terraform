output "bucket_attachments_access" {
  value = aws_iam_policy.bucket_attachments_access
}

output "bucket_uploads_access" {
  value = aws_iam_policy.bucket_uploads_access
}

output "bucket_submissions_access" {
  value = aws_iam_policy.bucket_submissions_access
}

output "bucket_tooling_jobs_write" {
  value = aws_iam_policy.bucket_tooling_jobs_write
}

output "bucket_tooling_jobs_access" {
  value = aws_iam_policy.bucket_tooling_jobs_access
}

output "cloudfront_distribution_assets" {
  value = aws_cloudfront_distribution.assets
}

output "cloudfront_distribution_icons" {
  value = aws_cloudfront_distribution.icons
}
