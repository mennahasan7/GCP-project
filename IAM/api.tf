# Enable services in newly created GCP Project.
resource "google_project_service" "gcp-services" {
  count   = length(var.gcp_service_list)
  project = var.project-ID
  service = var.gcp_service_list[count.index]
  disable_on_destroy = false
}
