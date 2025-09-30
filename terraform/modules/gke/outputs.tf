output "kubernetes_cluster_name" {
  value       = google_container_cluster.main.name
  description = "GKE Cluster Name"
}
output "kubernetes_cluster_host" {
  value       = google_container_cluster.main.endpoint
  description = "GKE Cluster Host"
}
output "kubernetes_cluster_location" {
  value = google_container_cluster.main.location
}
output "project_id" {
  value = var.project_id
}

output "primary_node_pool_id" {
  value = google_container_node_pool.standard
}

output "kubernetes_cluster_sa_email" {
  value = google_service_account.cluster.email
}

output "endpoint" {
  value = google_container_cluster.main.endpoint
}

output "client_certificate" {
  value = google_container_cluster.main.master_auth[0].client_certificate
}

output "client_key" {
  value = google_container_cluster.main.master_auth[0].client_key
}

output "cluster_ca_certificate" {
  value = google_container_cluster.main.master_auth[0].cluster_ca_certificate
}
