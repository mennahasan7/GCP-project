# Create private VM
resource "google_compute_instance" "management-instance" {
  name         = "management-instance"
  machine_type = var.vm_machine_type
  zone         = var.vm_zone
  boot_disk {
    initialize_params {
      image = var.vm_boot_disk_image
    }
  }

  # attach private-vm with management subnet
  network_interface {
    network    = var.vm_vpc
    subnetwork = var.vm_subnet
  }

  service_account {
    email = var.vm_service_account
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  metadata_startup_script = file("${path.module}/script.sh")

}
