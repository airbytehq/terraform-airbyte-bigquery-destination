variable "gcp_project_id" {
  type = string
  description = "The GCP Project ID where Airbyte will load data"
}

variable "airbyte_workspace_id" {
  type = string
  # TODO, docs to how would someone find this
  description = "The UUID of your airbyte workspace."
}

variable "dataset_info" {
  type = object({
    dataset_id = string
    dataset_location = string
  })
  description = <<EOT
    Information about the default Dataset ID and GCP location to use for your BigQuery data.
    The Location must be one of [BigQuery's supported locations](https://cloud.google.com/bigquery/docs/locations)
    ex. 
    ```
    {
      dataset_id = "all_of_my_data"
      dataset_location = "us-west1"
    }
    ```
    EOT
}

variable "destination_name" {
  type = string
  description = "A human readable name for your destination, often just the name of the destination type"
  default = "Destination BigQuery"
}

variable "service_account_id" {
  type = string
  description = "The unique account id for the service account airbyte uses to manage BigQuery resources"
  default = "airbyte-bq-controller"
}

variable "service_account_role_grants" {
  type = list(string)
  description = "The permissions granted to the the Airbyte BigQuery Controller Service Account"
  default = [ 
    "roles/bigquery.admin",
    "roles/storage.objectAdmin"
  ]
}

# pass through from airbyte_destination_bigquery
variable "big_query_client_buffer_size_mb" {
  type = number
  description = <<EOT
  Google BigQuery client's chunk (buffer) size (MIN=1, MAX = 15) for each table.
  The size that will be written by a single RPC. Written data will be buffered and only flushed upon
  reaching this size or closing the channel. The default 15MB value is used if not set explicitly.
  Read more [here](https://registry.terraform.io/providers/airbytehq/airbyte/latest/docs/resources/destination_bigquery#:~:text=explicitly.%20Read%20more-,here,-.)
  EOT
  default = 15
}

# pass through from airbyte_destination_bigquery
variable "transformation_priority" {
  type = string
  validation {
    condition = contains(["interactive", "batch"], var.transformation_priority)
    error_message = "The transformation_priority variable must be either `interactive` or `batch`."
  }
  description = <<EOT
    Interactive run type means that the query is executed as soon as possible, and these queries count towards concurrent rate limit
    and daily limit. Read more about interactive run type here. Batch queries are queued and started as soon as idle resources are available
    in the BigQuery shared resource pool, which usually occurs within a few minutes. Batch queries do not count towards your concurrent rate
    limit. Read more about batch queries here. The default "interactive" value is used if not set explicitly.
  EOT
  default = "interactive"
}

# Loading Method
variable "loading_method" {
  type = string
  description = "The Method for loading data into BigQuery, can be either `standard-inserts` or `gcs-staging` generally `gcs-staging` is more performant and efficient"
  validation {
    # TODO when this loading method issue is fixed, use this validation instead
    condition = contains(["gcs-staging", "standard-inserts"], var.loading_method)
    error_message = "The transformation_priority variable must be either `gcs-staging` or `standard-inserts`."
    # condition = contains(["standard-inserts"], var.loading_method)
    # error_message = "The transformation_priority variable must `standard-inserts`."
  }
  default = "gcs-staging"
  # default = "standard-inserts"
}

variable "gcs_bucket_info" {
  type = object({
    gcs_bucket_name = string
    gcs_bucket_path = optional(string, "")
  })
  nullable = true
  description = "If using the GCS Staging Loading method, provide the bucket and any path prefix you would like"
  default = null
}

variable "gcs_file_options" {
  type = object({
    keep_files_after_processing = bool
    file_buffer_count = number
  })
  description = "Advanced file handling options for the GCS Staging Loading Method"
  default = {
    keep_files_after_processing = false
    file_buffer_count = 10
  }
}
