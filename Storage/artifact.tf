resource "google_artifact_registry_repository" "my-repo" {
  location      = var.artifact_registry_location
  repository_id = "images-repository"
  description   = "docker repository"
  format        = "DOCKER"
}
