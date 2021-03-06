provider "google" {
  project = var.gcp_project_key
  region  = var.gcp_region
  zone    = var.gcp_zone
  credentials = var.gcp_account
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  metadata = {
    ssh-keys = "${var.gcp_ssh_key_username}:${var.gcp_public_key}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}
