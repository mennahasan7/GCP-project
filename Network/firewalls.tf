# Create IAP firwall 
resource "google_compute_firewall" "allow_vm_ssh" {
  name      = "allow-vm-ssh"
  network   = google_compute_network.vpc.id
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  # IAP ip ranges
  source_ranges = ["35.235.240.0/20"] 
}

