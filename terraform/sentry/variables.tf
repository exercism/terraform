variable "project_name" {
  description = "Base name for resources"
  type        = string
}

variable "organization_slug" {
  description = "Sentry organization slug"
  type        = string
}

variable "slack_workspace_id" {
  description = "Slack workspace ID for alert notifications"
  type        = string
}

variable "slack_channel_js" {
  description = "Slack channel for JS alert notifications"
  type        = string
}

variable "slack_channel_rails" {
  description = "Slack channel for Rails alert notifications"
  type        = string
}
