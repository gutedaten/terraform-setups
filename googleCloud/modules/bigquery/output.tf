output "dataset_id" {
  description = "ID of the BigQuery Dataset"
  value       = google_bigquery_dataset.lynx.dataset_id
}
