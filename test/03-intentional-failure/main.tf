resource "terraform_data" "guard" {
  input = {
    should_fail = var.should_fail
  }

  lifecycle {
    precondition {
      condition     = var.should_fail == false
      error_message = var.error_message
    }
  }
}
