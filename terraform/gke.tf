resource "google_container_cluster" "gke_cluster" {
  name     = var.gke_cluster_name
  location = var.region
  initial_node_count = var.node_count

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

output "gke_cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "bigquery_dataset" {
  value = google_bigquery_dataset.gamer_dataset.dataset_id
}

output "pubsub_topic" {
  value = google_pubsub_topic.cdc_events.name
}
