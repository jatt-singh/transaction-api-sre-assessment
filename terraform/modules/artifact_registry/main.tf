resource "google_artifact_registry_repository" "docker_repositories" {
  for_each = toset(var.repository_names)

  project      = var.project_id
  location     = var.primary_region
  repository_id = each.value
  format       = "DOCKER"
  description  = "Artifact Registry for Docker images"
}

# IAM policy binding to make specific repositories public
resource "google_artifact_registry_repository_iam_member" "public_access" {
  for_each = {
    for repo in var.repository_names : repo => var.repository_accessibility[repo]
    if var.repository_accessibility[repo] == "public"
  }

  project    = var.project_id
  location   = var.primary_region
  repository = each.key
  role       = "roles/artifactregistry.reader"
  member     = "allUsers"
}