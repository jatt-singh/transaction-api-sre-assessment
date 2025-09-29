# Configure the GCP Provider
provider "google" {
  project = var.project_id
  region  = var.primary_region
  zone    = var.primary_zone
}
provider "kubernetes" {
  host                   = "https://${module.gke_v2.endpoint}"
  cluster_ca_certificate = base64decode(module.gke_v2.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}


# provider "helm" {
#   kubernetes {
#     token                  = data.google_client_config.current.access_token
#     host                   = resource.google_container_cluster.main.endpoint
#     client_certificate     = base64decode(resource.google_container_cluster.main.master_auth.0.client_certificate)
#     client_key             = base64decode(resource.google_container_cluster.main.master_auth.0.client_key)
#     cluster_ca_certificate = base64decode(resource.google_container_cluster.main.master_auth.0.cluster_ca_certificate)
#   }
# }

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.10.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.10.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  required_version = ">= 1.9.4"
}
