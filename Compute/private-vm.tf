# Create private vm
resource "google_compute_instance" "management-vm" {
  name         = "management-vm"
  machine_type = var.vm_machine_type
  zone         = var.vm_zone
  boot_disk {
    initialize_params {
      image = var.vm_boot_disk_image
    }
  }

  # attach the vm with management subnet
  network_interface {
    network    = var.vm_vpc
    subnetwork = var.vm_subnet
  }
  # attach service account to the vm
  service_account {
    email = var.vm_service_account
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  metadata_startup_script = file("${path.module}/script.sh")
  depends_on = [ google_container_cluster.private-cluster,google_container_node_pool.cluster-node-pool ]
}
