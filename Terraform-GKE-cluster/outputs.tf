output "region" {
  value       = var.region
  description = "GCloud Region"
}
output "region_zone" {
  value       = var.region_zone
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {             # ip адрес мастер сервера у кластера
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

# 