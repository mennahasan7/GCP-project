# Creating private cluster ans associate it to workload subnet
resource "google_container_cluster" "private-cluster" {
  name     = "private-cluster"
  location = var.cluster_location
  # creating the least possible node pool  
  remove_default_node_pool = true
  initial_node_count       = 1
  node_locations           = var.cluster_node_location
  deletion_protection      = false
  network                  = var.cluster_vpc
  subnetwork               = var.cluster_subnet

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.cluster_management_subnet
      display_name = "management-subnet-cidr-range"
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_global_access_config { enabled = true }
    master_ipv4_cidr_block = "172.16.0.0/28"
  }
}

# Create GKE Node Pool to allows node pools to be added and removed without recreating the cluster
resource "google_container_node_pool" "nodepool" {
  name       = "nodepool"
  location   = google_container_cluster.private-cluster.location
  cluster    = google_container_cluster.private-cluster.name
  node_count = 1
  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    preemptible     = true
    machine_type    = var.cluster_node_machine_type
    disk_type       = var.cluster_node_disk_type
    disk_size_gb    = 50
    service_account = var.cluster_service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
