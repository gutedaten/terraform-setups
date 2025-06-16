resource "google_service_account" "datadash360" {
  account_id   = "datadash360"
  display_name = "DataDash360 Service Account"
}

resource "google_project_iam_member" "bigquery_admin" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.datadash360.email}"
}

resource "google_project_iam_member" "firebase_admin" {
  project = var.project_id
  role    = "roles/firebase.admin"
  member  = "serviceAccount:${google_service_account.datadash360.email}"
}
