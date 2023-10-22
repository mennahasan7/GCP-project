output vpc {
    value = google_compute_network.vpc
}

output management-subnet {
    value = google_compute_subnetwork.management-subnet
}

output workload-subnet {
    value = google_compute_subnetwork.workload-subnet
}