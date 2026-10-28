output "directory" {
  description = "Directory of the files on the worker"
  value       = local.directory
}

output "app_config_path" {
  description = "Delete or edit this file to create drift"
  value       = local_file.app_config.filename
}

output "welcome_path" {
  description = "Delete or edit this file to create drift"
  value       = local_file.welcome.filename
}
