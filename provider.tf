provider "google" {
  credentials = file("menna-402718-45372f46a487.json")
  project     = var.project-id
  region      = "us-central1"
}

