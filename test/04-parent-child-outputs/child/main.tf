locals {
  derived_name = "${var.parent_region}-${var.parent_vpc_name}-${var.child_suffix}"
  child_marker_path = "${path.module}/child-marker-${var.child_suffix}.txt"
}

resource "local_file" "child_marker" {
  filename = local.child_marker_path
  content = <<-EOT
Child Resource Information
Derived Name: ${local.derived_name}
Parent Region: ${var.parent_region}
Parent VPC Name: ${var.parent_vpc_name}
Parent Instance Count: ${var.parent_instance_count}
Child Suffix: ${var.child_suffix}
Created: ${timestamp()}
EOT
}
