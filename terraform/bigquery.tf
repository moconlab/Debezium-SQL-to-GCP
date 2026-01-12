# Create BigQuery dataset
resource "google_bigquery_dataset" "gamer_dataset" {
  dataset_id = var.dataset_id
  location   = var.region
}

# Servers table
resource "google_bigquery_table" "servers" {
  dataset_id = google_bigquery_dataset.gamer_dataset.dataset_id
  table_id   = "servers"
  schema = jsonencode([
    { name = "server_id", type = "STRING", mode = "REQUIRED" },
    { name = "ip", type = "STRING", mode = "REQUIRED" },
    { name = "country", type = "STRING", mode = "NULLABLE" },
    { name = "cost_price", type = "FLOAT", mode = "NULLABLE" },
    { name = "sell_price", type = "FLOAT", mode = "NULLABLE" },
    { name = "currency", type = "STRING", mode = "NULLABLE" },
    { name = "region", type = "STRING", mode = "NULLABLE" }
  ])
}

# Customers table
resource "google_bigquery_table" "customers" {
  dataset_id = google_bigquery_dataset.gamer_dataset.dataset_id
  table_id   = "customers"
  schema = jsonencode([
    { name = "customer_id", type = "STRING", mode = "REQUIRED" },
    { name = "name", type = "STRING", mode = "NULLABLE" },
    { name = "contact", type = "STRING", mode = "NULLABLE" },
    { name = "address", type = "STRING", mode = "NULLABLE" },
    { name = "country", type = "STRING", mode = "NULLABLE" }
  ])
}

# Game table
resource "google_bigquery_table" "game" {
  dataset_id = google_bigquery_dataset.gamer_dataset.dataset_id
  table_id   = "game"
  schema = jsonencode([
    { name = "game_id", type = "STRING", mode = "REQUIRED" },
    { name = "title", type = "STRING", mode = "NULLABLE" },
    { name = "release_date", type = "DATE", mode = "NULLABLE" },
    { name = "customer_id", type = "STRING", mode = "REQUIRED" }
  ])
}

# Server Assignment table
resource "google_bigquery_table" "server_assignment" {
  dataset_id = google_bigquery_dataset.gamer_dataset.dataset_id
  table_id   = "server_assignment"
  schema = jsonencode([
    { name = "server_id", type = "STRING", mode = "REQUIRED" },
    { name = "customer_id", type = "STRING", mode = "REQUIRED" },
    { name = "date", type = "DATE", mode = "REQUIRED" }
  ])
}

# Server Unassignment table
resource "google_bigquery_table" "server_unassignment" {
  dataset_id = google_bigquery_dataset.gamer_dataset.dataset_id
  table_id   = "server_unassignment"
  schema = jsonencode([
    { name = "server_id", type = "STRING", mode = "REQUIRED" },
    { name = "customer_id", type = "STRING", mode = "REQUIRED" },
    { name = "date", type = "DATE", mode = "REQUIRED" }
  ])
}
