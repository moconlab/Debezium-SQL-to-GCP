# Change Data Capture (CDC) Pipeline – SQL to BigQuery

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Project Overview

This project implements a **Change Data Capture (CDC) pipeline** that captures all database actions (inserts, updates, deletes) from a SQL database and streams them into **Google BigQuery** in near real-time.

The pipeline leverages:

* **Debezium** for CDC
* **Kafka Connect** or **Google Pub Sub** for streaming events
* **Google BigQuery** as the data warehouse
* **Kubernetes (GKE)** for container orchestration
* **Terraform** for infrastructure provisioning
* **Structured project code** for configuration and deployment

This setup allows organizations to **track all database changes**, perform **analytics on live data**, and maintain **auditable histories**.

---

## Features

* Capture **insert, update, and delete operations** from SQL databases
* Stream CDC events to **Kafka** and transform into **BigQuery tables**
* Infrastructure managed via **Terraform**
* Deploy all services on **Google Kubernetes Engine (GKE)**
* Flexible Debezium connectors for multiple database types (Postgres, MySQL, SQL Server)
* Full pipeline observability and logging
* Modular project code for connectors, topics, and transformations

---

## Architecture

```
+----------------+       +-------------------+       +--------------------+
| SQL Database   | --->  | Debezium Connector| --->  | Kafka / Kafka Connect |
| (Postgres / MySQL)|    |  (CDC Capture)   |       | (Streams CDC events) |
+----------------+       +-------------------+       +--------------------+
                                                          |
                                                          v
                                                +--------------------+
                                                | BigQuery           |
                                                | (CDC Sink / Tables)|
                                                +--------------------+

GKE Cluster hosts Debezium, Kafka Connect, and optional Kafka broker.
Terraform provisions GKE, network, IAM, and BigQuery datasets.
```

---

## Tech Stack

| Layer                   | Technology                                   |
| ----------------------- | -------------------------------------------- |
| CDC Capture             | Debezium                                     |
| Stream Platform         | Kafka / Kafka Connect                        |
| Data Warehouse          | BigQuery                                     |
| Container Orchestration | Kubernetes (GKE)                             |
| Infrastructure as Code  | Terraform                                    |
| Programming             | Python (connectors & transformations) |

---

## Setup & Deployment

### 1. Provision GKE and BigQuery with Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Terraform provisions:

* GKE cluster
* BigQuery dataset & tables
* Service accounts & IAM roles

---

### 2. Deploy Kafka & Debezium on GKE

```bash
kubectl apply -f k8s/kafka-debezium/
```

This includes:

* Kafka broker StatefulSet & service
* Zookeeper StatefulSet & service
* Debezium connectors for Postgres/MySQL
* Kafka Connect for streaming to BigQuery

---

### 3. Configure Debezium Connectors

Example **Postgres connector JSON**:

```json
{
  "name": "postgres-connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "postgres-db",
    "database.port": "5432",
    "database.user": "cdc_user",
    "database.password": "cdc_pass",
    "database.dbname": "mydb",
    "database.server.name": "postgres_server",
    "table.include.list": "public.*",
    "plugin.name": "pgoutput",
    "slot.name": "debezium_slot",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "transforms": "unwrap",
    "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
    "transforms.unwrap.drop.tombstones": "false"
  }
}
```

---

### 4. Stream CDC to BigQuery

Use **Kafka Connect BigQuery Sink Connector**:

```json
{
  "name": "bigquery-sink",
  "config": {
    "connector.class": "com.wepay.kafka.connect.bigquery.BigQuerySinkConnector",
    "tasks.max": "1",
    "topics": "postgres_server.public.my_table",
    "project": "<GCP_PROJECT_ID>",
    "dataset": "<BIGQUERY_DATASET>",
    "keyfile": "/path/to/service-account.json",
    "autoCreateTables": "true",
    "sanitizeTopics": "true"
  }
}
```

---

### 5. Deploy Connectors

```bash
curl -X POST -H "Content-Type: application/json" \
    --data @connectors/postgres-connector.json \
    http://<kafka-connect-service>:8083/connectors
```

---

## Project Structure

```
cdc-pipeline/
│
├── terraform/                  # Terraform scripts for GKE, BigQuery, IAM
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── k8s/                        # Kubernetes manifests
│   ├── kafka-debezium/
│   │   ├── kafka-deployment.yaml
│   │   ├── zookeeper-deployment.yaml
│   │   ├── debezium-connector.yaml
│   │   └── kafka-connect.yaml
│
├── connectors/                 # JSON connector configs
│   ├── postgres-connector.json
│   └── bigquery-sink.json
│
├── src/                        # Optional project code (Python/Java)
│   ├── transformations/
│   ├── utils/
│   └── main.py
│
├── README.md
└── LICENSE
```

---

## Monitoring & Logging

* Debezium logs are available via Kubernetes `kubectl logs`
* Kafka Connect exposes REST API for connector status
* BigQuery tables can be monitored via GCP console

---

## Usage

1. Upload CDC connectors via REST API
2. Start capturing changes from SQL databases
3. Verify streaming in BigQuery tables
4. Run analytical queries on real-time data

---

## Future Enhancements

* Add **schema evolution handling**
* Add **ML-based anomaly detection** on CDC data
* Implement **alerting for delayed events**
* Add **multi-database support**

---

## License

MIT License. See [LICENSE](LICENSE) for details.
