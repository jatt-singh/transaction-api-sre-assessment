resource "google_compute_network" "vpc" {
  provider = google-beta

  project                 = var.project_id
  name                    = "${var.application_name}-${var.environment_name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta
  project  = var.project_id

  name          = "${var.application_name}-${var.environment_name}-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_compute_subnetwork" "private" {
  project       = var.project_id
  name          = "${var.application_name}-${var.environment_name}-private-subnet"
  region        = var.primary_region
  network       = google_compute_network.vpc.self_link
  ip_cidr_range = cidrsubnet(var.network_cidr_block, 2, 1)

  # Enable private Google access for private connectivity to Google services
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_internet" {
  project = var.project_id
  name    = "fw-${var.application_name}-${var.environment_name}-allow-internet"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  allow {
    protocol = "icmp"
  }

  direction          = "EGRESS"
  description        = "Allow internet access"
  destination_ranges = ["0.0.0.0/0"]
  source_ranges      = [google_compute_subnetwork.private.ip_cidr_range]

  priority = 1000
}

# TODO: SSH through a bastion host for security
resource "google_compute_firewall" "allow_ssh" {
  project = var.project_id
  name    = "fw-${var.application_name}-${var.environment_name}-allow-ssh"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction          = "INGRESS"
  description        = "Allow ssh"
  source_ranges      = ["0.0.0.0/0"]
  destination_ranges = [google_compute_subnetwork.private.ip_cidr_range]

  priority = 65534
}

