terraform {
  backend "gcs" {
    bucket = "solid-authority-470915-b7-tfstate-12183fdc"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "backend" {
  name     = "${var.project_id}-tfstate-${random_id.bucket_suffix.hex}"
  location = "us-west1"

  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}