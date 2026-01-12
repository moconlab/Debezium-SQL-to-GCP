variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "dataset_id" {
  type    = string
  default = "gamer_hosting"
}

variable "gke_cluster_name" {
  type    = string
  default = "gamer-cdc-gke"
}

variable "node_count" {
  type    = number
  default = 3
}