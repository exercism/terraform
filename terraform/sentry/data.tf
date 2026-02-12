data "sentry_organization" "main" {
  slug = var.organization_slug
}

locals {
  organization_slug = data.sentry_organization.main.slug
}
