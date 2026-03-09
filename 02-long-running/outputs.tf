output "test_name" {
  description = "Name of this test run"
  value       = var.name
}

output "requested_wait_seconds" {
  description = "Configured wait duration in seconds"
  value       = var.wait_seconds
}

output "completed_at" {
  description = "Timestamp set after wait resource is complete"
  value       = time_sleep.long_task.id
}
