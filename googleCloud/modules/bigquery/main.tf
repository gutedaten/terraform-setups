resource "google_bigquery_dataset" "lynx" {
  dataset_id = "lynx"
  project    = var.project_id
  location   = "europe-west3"
}

resource "google_bigquery_table" "table1" {
  dataset_id = google_bigquery_dataset.lynx.dataset_id
  table_id   = "table1"
  schema     = jsonencode([
    { name = "id",    type = "STRING",  mode = "REQUIRED" },
    { name = "value", type = "INTEGER", mode = "NULLABLE" }
  ])
}

resource "google_bigquery_table" "table2" {
  dataset_id = google_bigquery_dataset.lynx.dataset_id
  table_id   = "table2"
  schema     = jsonencode([
    { name = "id",          type = "STRING", mode = "REQUIRED" },
    { name = "description", type = "STRING", mode = "NULLABLE" }
  ])
}

// Ansicht (View) zur Verknüpfung von table1 und table2
resource "google_bigquery_table" "view_lynx" {
  dataset_id = google_bigquery_dataset.lynx.dataset_id
  table_id   = "view_lynx"

  view {
    query          = <<-SQL
      SELECT
        t1.id,
        t1.value,
        t2.description
      FROM `${var.project_id}.lynx.table1` AS t1
      JOIN `${var.project_id}.lynx.table2` AS t2
        ON t1.id = t2.id
    SQL
    use_legacy_sql = false
  }
}
