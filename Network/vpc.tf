# Create VPC
resource "google_compute_network" "vpc" {
  project                 = var.project-ID
  name                    = "vpc"
  auto_create_subnetworks = false
}
