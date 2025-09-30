resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 120"
  }
  triggers = {
    "project" = "${var.project_id}"
  }
}
resource "google_project_service" "container" {
  project = var.project_id
  service = "container.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  # disable_dependent_services = true
  disable_on_destroy = false
  depends_on         = [null_resource.delay]
}

resource "google_project_service" "compute" {

  project = var.project_id
  service = "compute.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  # disable_dependent_services = true
  disable_on_destroy = false
  depends_on         = [null_resource.delay]
}

resource "google_project_service" "storage" {
  project = var.project_id
  service = "storage.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  # disable_dependent_services = true
  disable_on_destroy = false
  depends_on         = [null_resource.delay]
}

resource "google_project_service" "servicenetworking" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  # disable_dependent_services = true
  disable_on_destroy = false
  depends_on         = [null_resource.delay]
}
