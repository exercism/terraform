# JS project
resource "sentry_project" "js" {
  organization = local.organization_slug
  teams        = ["thalamus", "exercism"]
  name         = local.js_project
  slug         = local.js_project
  platform    = "javascript"
  resolve_age = 720

  lifecycle {
    prevent_destroy = true
  }
}

# Rails project
resource "sentry_project" "rails" {
  organization = local.organization_slug
  teams        = ["thalamus", "exercism"]
  name         = local.rails_project
  slug         = local.rails_project
  platform    = "ruby-rails"
  resolve_age = 720

  lifecycle {
    prevent_destroy = true
  }
}
