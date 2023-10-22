resource "google_artifact_registry_repository" "my-repo" {
  location      = var.artifact_registry_location
  repository_id = "project-images"
  description   = "docker repository"
  format        = "DOCKER"
}
