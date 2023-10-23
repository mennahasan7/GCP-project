# Create service account for vm
resource "google_service_account" "vm-sa" {
  account_id   = "vm-service-account"
  display_name = "vm-service-account"
}

# Create service account for gke
resource "google_service_account" "cluster-sa" {
  account_id   = "cluster-service-account"
  display_name = "cluster-service-account"
}

