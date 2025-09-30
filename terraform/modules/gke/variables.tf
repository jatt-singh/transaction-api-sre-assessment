# Infrastructure variables
# variable "gcp_organization" {
#   type = string
# }
variable "project_id" {
  type = string
}
variable "primary_region" {
  type = string
}
variable "primary_zone" {
  type = string
}
# Sizing variables
# Standard node pool
variable "standard_min_node_count" {
  type = number
}
variable "standard_max_node_count" {
  type = number
}
variable "standard_node_size" {
  type = string
}

# Application variables
variable "app_name" {
  type = string
}
variable "env_name" {
  type = string
}
variable "network" {
  type = string
}

variable "subnetwork" {
  type = string

}
variable "standard_node_locations" {
  type = list(string)
}

variable "cluster_node_locations" {
  type = list(string)
}