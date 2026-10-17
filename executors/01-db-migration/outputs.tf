output "target" {
  description = "Database the migrations were applied to"
  value       = local.target
}

output "applied_migrations" {
  description = "Applied dummy migration versions"
  value       = terraform_data.migration[*].output.version
}
