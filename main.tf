terraform {
  required_providers {
    # TODO: Make versions not hard pinned
    google = {
      source = "hashicorp/google"
      version = ">= 4.74.0"
    }

    airbyte = {
      source = "airbytehq/airbyte"
      version = "~> 0.3.1"
    }

  }
}
