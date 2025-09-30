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
