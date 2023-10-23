# set values for IAM modules variables
module "IAM" {
  source     = "./IAM"
  project-ID = var.project-id
  gcp_service_list = [
    "cloudresourcemanager.googleapis.com", #Cloud Resource Manager API
    "compute.googleapis.com",              # Compute Engine API
    "artifactregistry.googleapis.com",     # Artifact Registry API
    "container.googleapis.com"             # Kubernetes Engine API
  ]
}

# set values for Network modules variables
module "Network" {
  source                   = "./Network"
  project-ID               = var.project-id
  management-subnet-cidr   = "10.0.0.0/16"
  management-subnet-region = "us-central1"
  workload-subnet-cidr     = "10.1.0.0/16"
  workload-subnet-region   = "asia-east1"
  depends_on               = [module.IAM]
}

# set values for Compute modules variables
module "Compute" {
  source             = "./Compute"
  vm_machine_type    = "e2-medium"
  vm_zone            = "us-central1-a"
  vm_boot_disk_image = "ubuntu-os-cloud/ubuntu-2004-lts"
  vm_vpc             = module.Network.vpc.id
  vm_subnet          = module.Network.management-subnet.id
  vm_service_account = module.IAM.vm-sa.email
  cluster_location   = "asia-east1"
  node_locations = [
    "asia-east1-a",
    "asia-east1-b",
    "asia-east1-c"
  ]
  cluster_node_machine_type = "n1-standard-1"
  cluster_node_disk_type    = "pd-standard"
  cluster_node_disk_size_gb = 50
  cluster_vpc               = module.Network.vpc.id
  cluster_subnet            = module.Network.workload-subnet.id
  cluster_management_subnet = module.Network.management-subnet.ip_cidr_range
  cluster_service_account   = module.IAM.cluster-sa.email
  depends_on                = [module.IAM, module.Storage]
}

# set values for Storage modules variables
module "Storage" {
  source                     = "./Storage"
  artifact_registry_location = "us-central1"
  depends_on                 = [module.IAM]
}

