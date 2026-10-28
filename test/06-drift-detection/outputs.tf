output "path" {
  description = "Path of the managed file; delete it to cause drift"
  value       = local_file.managed.filename
}

output "content_sha256" {
  description = "SHA-256 of the managed file content"
  value       = local_file.managed.content_sha256
}
