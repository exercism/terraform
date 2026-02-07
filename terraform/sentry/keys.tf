resource "sentry_key" "js" {
  organization = local.organization_slug
  project      = sentry_project.js.slug
  name         = "Default"
}

resource "sentry_key" "rails" {
  organization = local.organization_slug
  project      = sentry_project.rails.slug
  name         = "Default"
}
