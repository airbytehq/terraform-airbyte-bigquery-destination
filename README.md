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

## Errors so far

### Error: unexpected response from API. Got an unexpected response code 422
I got this trying to set up a GCS staging destination.

```
  # module.bq_destination.airbyte_destination_bigquery.bigquery_destination_gcs_staging[0] will be created
  + resource "airbyte_destination_bigquery" "bigquery_destination_gcs_staging" {
      + configuration    = {
          + big_query_client_buffer_size_mb = 15
          + credentials_json                = (sensitive value)
          + dataset_id                      = "terraform_test"
          + dataset_location                = "us-west1"
          + destination_type                = "bigquery"
          + loading_method                  = {
              + destination_bigquery_loading_method_gcs_staging = {
                  + credential               = {
                      + destination_bigquery_loading_method_gcs_staging_credential_hmac_key = {
                          + credential_type    = "HMAC_KEY"
                          + hmac_key_access_id = "GOOG1E5EWZ2U35CUNFBWGY57OMQPDNE47U4GHNUAKAQ3EEVGFVO7DNCRTINTQ"
                          + hmac_key_secret    = (sensitive value)
                        }
                    }
                  + file_buffer_count        = 10
                  + gcs_bucket_name          = "joes-ab-terraform-stuff"
                  + gcs_bucket_path          = ""
                  + keep_files_in_gcs_bucket = "Delete all tmp files from GCS"
                  + method                   = "GCS Staging"
                }
            }
          + project_id                      = "destinations-v2"
          + transformation_priority         = "interactive"
        }
      + destination_id   = (known after apply)
      + destination_type = (known after apply)
      + name             = "Destination BigQuery"
      + workspace_id     = "1bf66663-b6b1-48bc-9bb0-6091bf320ca7"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

The Error
```
**Response**:
│ HTTP/2.0 422 Unprocessable Entity
│ Content-Length: 348
│ Alt-Svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
│ Content-Type: application/problem+json
│ Date: Wed, 19 Jul 2023 18:17:16 GMT
│ Server: envoy
│ Via: 1.1 google
│ X-Content-Type-Options: nosniff
│ X-Frame-Options: SAMEORIGIN
│ X-Xss-Protection: 0
│ 
│ {"type":"https://reference.airbyte.com/reference/errors#unprocessable-entity","title":"unprocessable-entity","status":422,"detail":"The provided configuration does not fulfill the specification. Errors: json schema validation failed when comparing the data to the json schema. \nErrors:
│ $.loading_method.method: must be a constant value Standard "}
```

### Unexpected End of JSON input
I got this trying to set up a standard inserts destination
The Plan
```

Terraform will perform the following actions:

  # module.bq_destination.airbyte_destination_bigquery.bigquery_destination_standard_inserts[0] will be created
  + resource "airbyte_destination_bigquery" "bigquery_destination_standard_inserts" {
      + configuration    = {
          + big_query_client_buffer_size_mb = 15
          + credentials_json                = (sensitive value)
          + dataset_id                      = "terraform_test"
          + dataset_location                = "us-west1"
          + destination_type                = "bigquery"
          + loading_method                  = {
              + destination_bigquery_loading_method_standard_inserts = {
                  + method = "Standard"
                }
            }
          + project_id                      = "destinations-v2"
          + transformation_priority         = "interactive"
        }
      + destination_id   = (known after apply)
      + destination_type = (known after apply)
      + name             = "Destination BigQuery"
      + workspace_id     = "1bf66663-b6b1-48bc-9bb0-6091bf320ca7"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

The Error
```
 Error: failure to invoke API
│ 
│   with module.bq_destination.airbyte_destination_bigquery.bigquery_destination_standard_inserts[0],
│   on .terraform/modules/bq_destination/airbyte_big_query_destination.tf line 25, in resource "airbyte_destination_bigquery" "bigquery_destination_standard_inserts":
│   25: resource "airbyte_destination_bigquery" "bigquery_destination_standard_inserts" {
│ 
│ error serializing request body: json: error calling MarshalJSON for type *shared.DestinationBigqueryLoadingMethod: json: error calling MarshalJSON for type shared.DestinationBigqueryLoadingMethodGCSStagingCredential: unexpected end of JSON input
```
