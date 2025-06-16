output "service_account_email" {
  description = "E-Mail des Service Accounts"
  value       = google_service_account.datadash360.email
}

output "service_account_key_json" {
  description = "JSON-Content des Service Account Keys"
  value       = google_service_account_key.datadash360_key.private_key
  sensitive   = true
}

output "service_account_key_id" {
  description = "ID des Service Account Keys"
  value       = google_service_account_key.datadash360_key.id
}
