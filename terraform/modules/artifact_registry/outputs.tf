output "repository_urls" {
  value = {
    for repo, details in google_artifact_registry_repository.docker_repositories :
    repo => "https://${details.location}-docker.pkg.dev/${details.project}/${details.repository_id}"
  }
}