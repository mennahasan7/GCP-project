# grant access to vm service account usinf iam binding
resource "google_project_iam_binding" "vm-sa-binding1" {
  project = var.project-ID
  role    = "roles/container.admin"
  members = [
    "serviceAccount:${google_service_account.vm-sa.email}"
  ]
}

resource "google_project_iam_binding" "vm-sa-binding2" {
  project = var.project-ID
  role    = "roles/artifactregistry.writer"
  members = [
    "serviceAccount:${google_service_account.vm-sa.email}"
  ]
}

resource "google_project_iam_binding" "gke-sa-binding1" {
  project = var.project-ID
  role    = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.gke-sa.email}"
  ]
}


