variable "project_name" {
  description = "Base name for resources"
  type        = string
}

variable "organization_slug" {
  description = "Sentry organization slug"
  type        = string
}

variable "ops_handler_service_slug" {
  description = "Sentry service slug for the Ops Handler internal integration"
  type        = string
}
