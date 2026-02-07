output "js_project_slug" {
  description = "Sentry project slug for JS"
  value       = sentry_project.js.slug
}

output "rails_project_slug" {
  description = "Sentry project slug for Rails"
  value       = sentry_project.rails.slug
}

output "js_dsn" {
  description = "Sentry DSN for JS project"
  value       = sentry_key.js.dsn_public
}

output "rails_dsn" {
  description = "Sentry DSN for Rails project"
  value       = sentry_key.rails.dsn_public
}
