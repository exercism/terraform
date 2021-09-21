resource "aws_cloudfront_function" "domain_redirector" {
  name    = "domain-redirector"
  runtime = "cloudfront-js-1.0"
  comment = "my function"
  publish = true
  code    = file("${path.module}/function.js")
}
