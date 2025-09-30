
# Call the VPC module

# Call the project_services module

module "project_services" {
  source      = "./modules/project_services"
  project_id  = var.project_id
}

module "vpc" {
  source              = "./modules/vpc"
  project_id          = var.project_id
  application_name    = var.application_name
  environment_name    = var.environment_name
  network_cidr_block  = var.network_cidr_block
  primary_region      = var.primary_region
  primary_zone        = var.primary_zone
}

# Call the GKE module
module "gke" {
  source                        = "./modules/gke"
  project_id                    = var.project_id
  app_name                      = var.app_name
  env_name                      = var.env_name
  primary_zone                  = var.primary_zone
  primary_region                = var.primary_region
  standard_node_size            = var.standard_node_size
  standard_min_node_count       = var.standard_min_node_count
  standard_max_node_count       = var.standard_max_node_count
  network                       = module.vpc.vpc_self_link
  subnetwork                    = module.vpc.private_vpc_self_link
  standard_node_locations       = var.standard_node_locations
  cluster_node_locations        = var.cluster_node_locations
}

module "artifact_registry" {
  source          = "./modules/artifact_registry"
  project_id      = var.project_id
  primary_region  = var.primary_region
  repository_names = var.repository_names
  repository_accessibility = var.repository_accessibility
}

