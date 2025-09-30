resource "google_container_cluster" "main" {
  project  = var.project_id
  name     = "gke-${var.app_name}-${var.env_name}-cluster"
  location = var.primary_region
  node_locations = var.cluster_node_locations
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  # Disable auto-upgrade for the cluster
  release_channel {
    channel = "UNSPECIFIED"
  }

  network    = var.network
  subnetwork = var.subnetwork

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "standard" {
  project    = var.project_id
  name       = "gke-${var.app_name}-${var.env_name}-standard"
  location   = var.primary_region
  cluster    = google_container_cluster.main.name
  node_locations = var.standard_node_locations
  
  autoscaling {
    total_min_node_count = var.standard_min_node_count
    total_max_node_count = var.standard_max_node_count
  }

  node_config {
    preemptible  = false
    spot         = false
    machine_type = var.standard_node_size

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.cluster.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}


#cluster-iam-role
locals {
  cluster_roles = [
    "roles/storage.objectUser",
    "roles/storage.insightsCollectorService",
    "roles/artifactregistry.reader",
    "roles/container.defaultNodeServiceAccount"
  ]

  cluster_members = [
    "serviceAccount:${google_service_account.cluster.email}",

  ]

  # Create a flat map of role-member pairs
  role_member_pairs = flatten([
    for role in local.cluster_roles : [
      for member in local.cluster_members : {
        role   = role
        member = member
      }
    ]
  ])
}

resource "google_service_account" "cluster" {
  project      = var.project_id
  account_id   = "sa-gke-${var.app_name}-${var.env_name}"
  display_name = "sa-gke-${var.app_name}-${var.env_name}"
}

# Assign roles to each member individually using google_project_iam_member
resource "google_project_iam_member" "cluster_roles" {
  for_each = {
    for role in local.cluster_roles : role => {
      role   = role
      member = "serviceAccount:${google_service_account.cluster.email}"
    }
  }

  depends_on = [google_service_account.cluster]

  project = var.project_id
  role    = each.value.role
  member  = each.value.member
}

resource "google_project_iam_member" "node_default_role" {
  project = var.project_id
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.cluster.email}"
}
