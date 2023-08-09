# Setup a BigQuery Destination in Airbyte
This module will create everything needed to set up a BigQuery destination.

## !!! Known Issues !!!
The following issues are present with this module

### GCS Staging Loading Method not setup correctly
The module will create the destination and GCP resources just fine, the 
terraform apply will succeed, but when verifying the destination in Airbyte Cloud it is not set properly.

Temporarily disabling the use of GCS Staging Loading method with this module

## Example usage
```
terraform {
  required_providers {
    airbyte = {
      source = "airbytehq/airbyte"
      version = "0.3.0"
    }

    google = {
      source = "hashicorp/google"
      version = "4.74.0"
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
  # Configuration options
  bearer_auth = local.airbyte_api_key
}

provider "google" {
  project = local.google_project
}

resource "google_bigquery_dataset" "test_dataset_destination" {
  dataset_id = local.dataset_id
}

resource "google_storage_bucket" "test_bucket" {
  name = local.bucket_name
  location = local.dataset_location
}

module "bq_destination" {
  source = "github.com/airbytehq/airbyte-terraform-bigquery-destination"
  gcp_project_id = local.google_project
  airbyte_workspace_id = local.airbyte_workspace_id
  dataset_info = {
    dataset_id = google_bigquery_dataset.test_dataset_destination.dataset_id
    dataset_location = lower(google_storage_bucket.test_bucket.location)
  }
  gcs_bucket_info = {
    gcs_bucket_name = google_storage_bucket.test_bucket.name
  }
}
```

The above example also creates a BigQuery Dataset and GCS Bucket, but you can pass in existing datasets or buckets
by using the `data` source instead, i.e.

```
terraform {
  required_providers {
    airbyte = {
      source = "airbytehq/airbyte"
      version = "0.3.0"
    }

    google = {
      source = "hashicorp/google"
      version = "4.74.0"
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
  # Configuration options
  bearer_auth = local.airbyte_api_key
}

provider "google" {
  project = local.google_project
}

# This references an existing dataset
data "google_bigquery_dataset" "test_dataset_destination" {
  dataset_id = local.dataset_id
}

# This references an existing gcs bucket
data "google_storage_bucket" "test_bucket" {
  name = local.bucket_name
}

module "bq_destination" {
  source = "github.com/airbytehq/airbyte-terraform-bigquery-destination"
  gcp_project_id = local.google_project
  airbyte_workspace_id = "YOUR-AIRBYTE-WORKSPACE-ID"
  dataset_info = {
    # Note: These are now prefixed with `data.`
    dataset_id = data.google_bigquery_dataset.test_dataset_destination.dataset_id
    dataset_location = lower(data.google_storage_bucket.test_bucket.location)
  }
  gcs_bucket_info = {
    gcs_bucket_name = google_storage_bucket.test_bucket.name
  }
}
```

See the `variables.tf` file for more configuration options.
