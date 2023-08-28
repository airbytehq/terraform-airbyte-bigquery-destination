terraform {
  required_providers {
    airbyte = {
      source = "airbytehq/airbyte"
      version = "~> 0.3.3"
    }

    google = {
      source = "hashicorp/google"
      version = "~> 4.74.0"
    }
  }
}

# Replace all of these values!
locals {
  airbyte_api_key = "TODO" # ex. "asdlfkjasdlfjalsdfjk" or use file("/path/to/airbyte_api.key")
  airbyte_workspace_id = "TODO" # ex. "ASDFASDFASDFASDFASDF"
  google_project = "TODO" # ex. "my-project"
  dataset_id = "TODO" # ex. "my_dataset_id"
  dataset_location = "TODO" # ex. "us-west-1"
  bucket_name = "TODO" # ex. "my-bucket"
}

provider "airbyte" {
  bearer_auth = local.airbyte_api_key
}

# If you're using OSS, create your airbyte provider like so
# provider "airbyte" {
#   # Configuration options
#   username   = var.airbyte_username
#   password   = var.airbyte_password
#   server_url = var.airbyte_server_url # maybe "http://localhost:8006/v1"
# }

provider "google" {
  project = local.google_project
}

# This references an existing gcs bucket
data "google_storage_bucket" "test_bucket" {
  name = local.bucket_name
}

module "bq_destination" {
  source = "github.com/airbytehq/terraform-airbyte-bigquery-destination"
  gcp_project_id = local.google_project
  airbyte_workspace_id = "YOUR-AIRBYTE-WORKSPACE-ID"
  dataset_info = {
    dataset_id = local.dataset_id
    dataset_location = lower(data.google_storage_bucket.test_bucket.location)
  }
  gcs_bucket_info = {
    gcs_bucket_name = data.google_storage_bucket.test_bucket.name
  }
}
