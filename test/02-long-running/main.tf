resource "time_sleep" "long_task" {
  create_duration = "${var.wait_seconds}s"
}
