output "firestore_database_name" {
  description = "Name of the Firestore Database"
  value       = google_firestore_database.default.name
}
