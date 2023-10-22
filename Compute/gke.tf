# Creating private cluster ans associate it to workload subnet
resource "google_container_cluster" "private-cluster" {
  name     = "private-cluster"
  location = var.cluster_location
  remove_default_node_pool = true
  initial_node_count       = 1
  node_locations           = var.cluster_node_location
  deletion_protection      = false
  # attach the cluster with workload subnet
  network                  = var.cluster_vpc
  subnetwork               = var.cluster_subnet
  # ip ranges that can access the private cluster
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.cluster_management_subnet
      display_name = "management-subnet-ip-cidr-block"
    }
  }
  # configuration for private cluster
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_global_access_config { enabled = true }
    master_ipv4_cidr_block = "172.16.0.0/28"
  }
}

# Create cluster Node Pool to allows node pools to be added and removed without re-creating the cluster
resource "google_container_node_pool" "nodepool" {
  name       = "nodepool"
  location   = google_container_cluster.private-cluster.location
  cluster    = google_container_cluster.private-cluster.name
  node_count = 1
  # cluster nodes configuration
  node_config {
    preemptible     = true
    machine_type    = var.cluster_node_machine_type
    disk_type       = var.cluster_node_disk_type
    disk_size_gb    = 50

    # attach service account to the cluster
    service_account = var.cluster_service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
