output "instance_link" {
  value       = google_sql_database_instance.instance.self_link
  description = "Instance Link"
}

output "database_link" {
  value       = google_sql_database.database.self_link
  description = "Database Link"
}
