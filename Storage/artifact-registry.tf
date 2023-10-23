# create artifact registry to store the mongodb and node app images
resource "google_artifact_registry_repository" "my-repo" {
  location      = var.artifact_registry_location
  repository_id = "project-images"
  description   = "docker repository"
  format        = "DOCKER"
}
