output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "subnet_id" {
  value = google_compute_subnetwork.private.id
}
output "vpc_self_link" {
  description = "The self_link of the created VPC."
  value       = google_compute_network.vpc.self_link
}
output "private_vpc_self_link" {
  value = google_compute_subnetwork.private.self_link
}
output "subnet_ip_cidr_range" {
  value = google_compute_subnetwork.private.ip_cidr_range
}
output "reserved_peering_ranges" {
  value = google_compute_global_address.private_ip_address.name
}
