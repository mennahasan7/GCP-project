# Create router for nat gateway
resource "google_compute_router" "router" {
  name    = "router"
  region  = google_compute_subnetwork.management-subnet.region
  network = google_compute_network.vpc.id
}

# Create nat gateway for management subnet
resource "google_compute_router_nat" "nat-gateway" {
  name                               = "nat-gateway"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.management-subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}