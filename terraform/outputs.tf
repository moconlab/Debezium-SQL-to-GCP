output "gke_cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "gke_cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "bigquery_dataset" {
  value = google_bigquery_dataset.cdc_dataset.dataset_id
}
