# grant access to vm service account usinf iam binding
resource "google_project_iam_member" "vm-sa-role1" {
  project = var.project-ID
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.vm-sa.email}"
}

resource "google_project_iam_member" "vm-sa-role2" {
  project = var.project-ID
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.vm-sa.email}"
}

resource "google_project_iam_member" "gke-sa-role1" {
  project = var.project-ID
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.gke-sa.email}"
}

resource "google_project_iam_member" "gke-sa-role2" {
  project = var.project-ID
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke-sa.email}"
}
