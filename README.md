# Setup a BigQuery Destination in Airbyte
This module will create everything needed to set up a BigQuery destination.

## Example usage
```
provider "airbyte" {
  # Configuration options
  bearer_auth = file("path/to/your/airbyte_api.key") # replace with your key path
}

provider "google" {
  project = "your-project" # replace with your google project
}

resource "google_bigquery_dataset" "test_dataset_destination" {
  dataset_id = "terraform_test" # # replace with your dataset name
}

resource "google_storage_bucket" "test_bucket" {
  name = "your-bucket" # replace with your bucket name
  location = "us-west1"
}

module "bq_destination" {
  source = "github.com/airbytehq/airbyte-terraform-bigquery-destination"
  gcp_project_id = "your-project"
  airbyte_workspace_id = "YOUR-AIRBYTE-WORKSPACE-ID"
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
provider "airbyte" {
  # Configuration options
  bearer_auth = file("path/to/your/airbyte_api.key") # replace with your key path
}

provider "google" {
  project = "your-project" # replace with your google project
}

# This references an existing dataset
data "google_bigquery_dataset" "test_dataset_destination" {
  dataset_id = "terraform_test" # # replace with your dataset name
}

# This references an existing gcs bucket
data "google_storage_bucket" "test_bucket" {
  name = "your-bucket" # replace with your bucket name
}

module "bq_destination" {
  source = "github.com/airbytehq/airbyte-terraform-bigquery-destination"
  gcp_project_id = "your-project"
  airbyte_workspace_id = "YOUR-AIRBYTE-WORKSPACE-ID"
  dataset_info = {
    dataset_id = google_bigquery_dataset.test_dataset_destination.dataset_id
    dataset_location = lower(google_storage_bucket.test_bucket.location)
  }
  gcs_bucket_info = {
    gcs_bucket_name = google_storage_bucket.test_bucket.name
  }
}
```

See the `variables.tf` file for more configuration options.
