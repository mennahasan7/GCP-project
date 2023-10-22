variable "project-ID" {
  type        = string
  description = "this is project id"
}

variable "gcp_service_list" {
  description = "List of GCP service to be enabled for a project."
  type        = list(any)
}