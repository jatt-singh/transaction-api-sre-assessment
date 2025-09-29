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
variable "standard_node_count" {
  type = number
}
variable "standard_min_node_count" {
  type = number
}
variable "standard_max_node_count" {
  type = number
}
variable "standard_node_size" {
  type = string
}

variable "network_cidr_block" {
  type = string
}

# Application variables
variable "application_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "app_name" {
  type = string
}
variable "env_name" {
  type = string
}
variable "standard_node_locations" {
  type = list(string)
}

variable "cluster_node_locations" {
  type = list(string)
}



variable "service_account_name" {
  description = "Name of the Kubernetes Service Account."
  type        = string
}


variable "repository_names" {
  type = list(string)
}
variable "repository_accessibility" {
  type = map(string)
  description = <<EOT
A map defining the accessibility of each repository. 
Set the value to "public" to make the repository public, and "private" to keep it private.
Example:
{
  "transaction-api" = "private"
}
EOT
}