output "deployment_id" {
  description = "Random deployment identifier"
  value       = random_id.deployment.hex
}

output "instance_names" {
  description = "Generated dummy instance names"
  value       = random_pet.instance[*].id
}

output "tags" {
  description = "Tags attached to the dummy deployment"
  value       = terraform_data.deployment.output.tags
}
