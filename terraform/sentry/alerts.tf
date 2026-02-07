# Alert rules for JS project
resource "sentry_issue_alert" "js_slack" {
  organization = local.organization_slug
  project      = sentry_project.js.slug
  name         = local.js_alert_name

  action_match = "any"
  filter_match = "all"
  frequency    = 1440

  conditions_v2 = [
    { first_seen_event = {} }
  ]

  actions_v2 = [
    {
      slack_notify_service = {
        workspace       = var.slack_workspace_id
        channel         = var.slack_channel_js
        delivery_method = "slack"
      }
    }
  ]
}

# Alert rules for Rails project
resource "sentry_issue_alert" "rails_slack" {
  organization = local.organization_slug
  project      = sentry_project.rails.slug
  name         = local.rails_alert_name

  action_match = "any"
  filter_match = "all"
  frequency    = 1440

  conditions_v2 = [
    { first_seen_event = {} }
  ]

  actions_v2 = [
    {
      slack_notify_service = {
        workspace       = var.slack_workspace_id
        channel         = var.slack_channel_rails
        delivery_method = "slack"
      }
    }
  ]
}
