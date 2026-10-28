# Files stand in for cloud objects. The local provider compares a file with the state when it refreshes:
# a deleted file, or a file whose content changed, is reported as "has been deleted" outside of OpenTofu.

locals {
  directory = "${var.drift_dir}/${var.name}"
}

resource "local_file" "app_config" {
  filename = "${local.directory}/app-config.json"
  content = jsonencode({
    environment = var.environment
    replicas    = var.replicas
  })
  file_permission = "0644"
}

resource "local_file" "welcome" {
  filename        = "${local.directory}/welcome.txt"
  content         = "${var.welcome_message}\n"
  file_permission = "0644"
}

# Doesn't exist outside of the state, so it never drifts: a control object for the drift check.
resource "terraform_data" "release" {
  input = {
    environment = var.environment
    replicas    = var.replicas
  }
}
