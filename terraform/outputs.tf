output "project_id" {
  value = var.project_id
}



output "vpc_self_link" {
  description = "The self_link of the created VPC."
  value       = module.vpc.vpc_self_link
}
output "private_vpc_self_link" {
  value = module.vpc.private_vpc_self_link
}
output "subnet_ip_cidr_range" {
  value = module.vpc.subnet_ip_cidr_range
}
output "reserved_peering_ranges" {
  value = module.vpc.reserved_peering_ranges
}
output "vpc_id" {
  value = module.vpc.vpc_id
}


#gke (regional) outputs
output "kubernetes_cluster_name" {
  value       = module.gke.kubernetes_cluster_name
  description = "GKE Cluster Name"
}
output "kubernetes_cluster_host" {
  value       = module.gke.kubernetes_cluster_host
  description = "GKE Cluster Host"
}
output "kubernetes_cluster_location" {
  value = module.gke.kubernetes_cluster_location
}
output "gke_primary_node_pool_id" {
  value = module.gke.primary_node_pool_id
}

output "kubernetes_cluster_sa_email" {
  value = module.gke.kubernetes_cluster_sa_email
}
output "gke_endpoint_cluster" {
  value = module.gke.endpoint
}
output "gke_client_certificate" {
  value = module.gke.client_certificate
}
output "gke_client_key" {
  value = module.gke.client_key
  sensitive = true
}
output "gke_cluster_ca_certificate" {
  value = module.gke.cluster_ca_certificate
}

output "repository_url" {
  description = "The URL of the Artifact Registry repository"
  value       = module.artifact_registry.repository_urls
}