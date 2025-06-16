resource "google_firebase_project" "default" {
  provider = google-beta
  project  = var.project_id
}

resource "google_firestore_database" "default" {
  provider    = google-beta
  name        = "(default)"
  project     = var.project_id
  location_id = "europe-west3"
  type        = "FIRESTORE_NATIVE"
}

resource "google_firestore_field" "device_expireAt" {
  provider    = google-beta
  project     = var.project_id
  database    = google_firestore_database.default.name
  collection  = "device"
  field       = "expireAt"
  ttl_config {
    state = "ENABLED"
  }
}
