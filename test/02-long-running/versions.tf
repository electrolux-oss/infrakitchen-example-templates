terraform {
  required_version = ">= 1.5.0"

  required_providers {
    time = {
      source  = "hashicorp/time"
      version = ">= 0.11.0"
    }
  }
}
