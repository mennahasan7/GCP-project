variable "vm_machine_type" {
  description = "machine type for instances"
  type        = string
}

variable "vm_zone" {
  description = "zone for instances"
  type        = string
}

variable "vm_boot_disk_image" {
  description = "image for instance boot disk"
  type        = string
}

variable "vm_vpc" {
  description = "vpc network for vm"
  type        = string
}

variable "vm_subnet" {
  description = "subnet network for vm"
  type        = string
}

variable "vm_service_account" {
  description = "service account for vm"
  type        = string
}

variable "cluster_location" {
  description = "location of standard cluster"
  type        = string
}

variable "cluster_node_location" {
  description = "List of locations for cluster nodes"
  type        = list(any)
}

variable "cluster_node_machine_type" {
  description = "machine type for cluster"
  type        = string
}

variable "cluster_node_disk_type" {
  description = "disk type for cluster"
  type        = string
}

variable "cluster_vpc" {
  description = "vpc network for cluster"
  type        = string
}

variable "cluster_subnet" {
  description = "subnet network for cluster"
  type        = string
}

variable "cluster_management_subnet" {
  description = "cidr range for management subnet"
  type        = string
}

variable "cluster_service_account" {
  description = "service account for cluster"
  type        = string
}