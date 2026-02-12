# Escalating issue alert for JS project
resource "sentry_issue_alert" "js_escalating" {
  organization = local.organization_slug
  project      = sentry_project.js.slug
  name         = "Escalating Issue"

  action_match = "any"
  filter_match = "all"
  frequency    = 180

  conditions_v2 = [
    {
      event_unique_user_frequency = {
        comparison_type = "count"
        value           = 10
        interval        = "1h"
      }
    },
    {
      event_unique_user_frequency = {
        comparison_type = "count"
        value           = 20
        interval        = "1d"
      }
    }
  ]

  actions_v2 = [
    {
      notify_event_service = {
        service = var.ops_handler_service_slug
      }
    }
  ]
}

# Escalating issue alert for Rails project
resource "sentry_issue_alert" "rails_escalating" {
  organization = local.organization_slug
  project      = sentry_project.rails.slug
  name         = "Escalating Issue"

  action_match = "any"
  filter_match = "all"
  frequency    = 180

  conditions_v2 = [
    {
      event_unique_user_frequency = {
        comparison_type = "count"
        value           = 10
        interval        = "1h"
      }
    },
    {
      event_unique_user_frequency = {
        comparison_type = "count"
        value           = 20
        interval        = "1d"
      }
    }
  ]

  actions_v2 = [
    {
      notify_event_service = {
        service = var.ops_handler_service_slug
      }
    }
  ]
}
