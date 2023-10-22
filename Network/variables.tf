variable "project-ID" {
  type        = string
  description = "this is project id"
}

variable "management-subnet-cidr" {
  type        = string
  description = "this is cidr block for management subnet"
}

variable "management-subnet-region" {
  type        = string
  description = "this is region for management subnet"
}

variable "workload-subnet-cidr" {
  type        = string
  description = "this is cidr block for workload subnet"
}

variable "workload-subnet-region" {
  type        = string
  description = "this is region for workload subnet"
}

