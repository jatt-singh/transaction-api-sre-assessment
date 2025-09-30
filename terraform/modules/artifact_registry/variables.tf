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
  "transaction-api" = "public"
  "transaction-db"  = "private"
}
EOT
}