locals {
  compat_output_path = "${path.module}/terraform-compat-output.txt"
}

resource "local_file" "compat_output" {
  filename = local.compat_output_path
  content = <<-EOT
Terraform/OpenTofu Compatibility Test
Organization: ${var.organization_name}
Environment: ${var.environment}
Metadata: ${jsonencode(var.metadata)}
Generated: ${timestamp()}
EOT
}
