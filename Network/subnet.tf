# Create Subnet for private vm
resource "google_compute_subnetwork" "management-subnet" {
  name          = "management-subnet"
  ip_cidr_range = var.management-subnet-cidr
  region        = var.management-subnet-region
  network       = google_compute_network.vpc.id
}

# Create Subnet for GKE cluster
resource "google_compute_subnetwork" "workload-subnet" {
  name          = "workload-subnet"
  ip_cidr_range = var.workload-subnet-cidr
  region        = var.workload-subnet-region
  network       = google_compute_network.vpc.id
}