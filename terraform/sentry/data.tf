data "sentry_organization" "main" {
  slug = var.organization_slug
}

data "sentry_organization_integration" "github" {
  organization = var.organization_slug
  provider_key = "github"
  name         = "exercism"
}

locals {
  organization_slug = data.sentry_organization.main.slug
}
