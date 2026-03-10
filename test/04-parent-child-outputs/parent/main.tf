locals {
  parent_marker_path = "${path.module}/parent-marker.txt"
}

resource "local_file" "parent_marker" {
  filename = local.parent_marker_path
  content = <<-EOT
Parent Resource Information
Region: ${var.region}
VPC Name: ${var.vpc_name}
Instance Count: ${var.instance_count}
Created: ${timestamp()}
EOT
}
