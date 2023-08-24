terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 4.74.0"
    }

    airbyte = {
      source = "airbytehq/airbyte"
      version = "~> 0.3.3"
    }

  }
}
