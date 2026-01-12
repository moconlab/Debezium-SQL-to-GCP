# Pub/Sub topic for CDC events
resource "google_pubsub_topic" "cdc_events" {
  name = "gamer-cdc-events"
}

# Optional: Subscription for downstream processing
resource "google_pubsub_subscription" "cdc_subscription" {
  name  = "gamer-cdc-sub"
  topic = google_pubsub_topic.cdc_events.name
  ack_deadline_seconds = 20
}
