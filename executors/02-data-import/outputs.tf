output "dataset" {
  description = "Imported dataset name"
  value       = terraform_data.import.output.dataset
}

output "record_ids" {
  description = "Identifiers of the imported dummy records"
  value       = terraform_data.import.output.records
}
