resource "google_firebase_project" "default" {
  project = var.project_id
}

resource "google_firestore_database" "default" {
  name        = "(default)"
  project     = var.project_id
  location_id = "europe-west3"
  type        = "FIRESTORE_NATIVE"
}

// TTL-Rule: Delete device documents automatically after expireAt field
resource "google_firestore_field" "device_expireAt" {
  project    = var.project_id
  database   = google_firestore_database.default.name
  collection = "device"
  field      = "expireAt"
  ttl_config {
    state = "ENABLED"
  }
}
