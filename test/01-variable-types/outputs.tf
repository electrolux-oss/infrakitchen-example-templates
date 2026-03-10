output "module_run_id" {
  description = "Random ID to prove apply execution"
  value       = random_id.module_run.hex
}

output "echo_name" {
  description = "Echo string variable"
  value       = local.normalized.name
}

output "echo_instance_count" {
  description = "Echo number variable"
  value       = local.normalized.instance_count
}

output "echo_enabled" {
  description = "Echo boolean variable"
  value       = local.normalized.enabled
}

output "echo_subnet_ids" {
  description = "Echo list(string) variable"
  value       = local.normalized.subnet_ids
}

output "echo_tags" {
  description = "Echo map(string) variable"
  value       = local.normalized.tags
}

output "echo_settings" {
  description = "Echo object variable"
  value       = local.normalized.settings
}

output "echo_services" {
  description = "Echo list(object) variable"
  value       = local.normalized.services
}

output "echo_availability_zones" {
  description = "Echo set(string) as list"
  value       = local.normalized.availability_zones
}

output "echo_dynamic_payload" {
  description = "Echo any variable"
  value       = local.normalized.dynamic_payload
}
