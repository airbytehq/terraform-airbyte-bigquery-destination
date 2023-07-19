# Setup a BigQuery Destination in Airbyte
Check the variables, will fill more info in later.

## Example usage
```
provider "airbyte" {
  # Configuration options
  bearer_auth = file("path/to/your/airbyte_api.key")
}

provider "google" {
  project = "your-project"
}

resource "google_bigquery_dataset" "test_dataset_destination" {
  dataset_id = "terraform_test"
}

resource "google_storage_bucket" "test_bucket" {
  name = "joes-ab-terraform-stuff"
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
