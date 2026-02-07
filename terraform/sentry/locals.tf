locals {
  project_name_title = title(var.project_name)

  # Project names/slugs
  js_project    = "${var.project_name}-js"
  rails_project = "${var.project_name}-rails"

  # Alert names
  js_alert_name    = "${local.project_name_title} JS Slack"
  rails_alert_name = "${local.project_name_title} Rails Slack"
}
