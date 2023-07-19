locals {
  formatted_keep_files_after_processing = var.gcs_file_options.keep_files_after_processing ? "Keep all tmp files in GCS" : "Delete all tmp files from GCS"
  standard_inserts_method = {method = "Standard"}
  gcs_staging_method = {
      # required
      method = "GCS Staging"
      gcs_bucket_name = var.gcs_bucket_info.gcs_bucket_name
      gcs_bucket_path = var.gcs_bucket_info.gcs_bucket_path
      # optional
      keep_files_in_gcs_bucket = local.formatted_keep_files_after_processing
      file_buffer_count = var.gcs_file_options.file_buffer_count
      credential = {
        destination_bigquery_update_loading_method_gcs_staging_credential_hmac_key = {
          credential_type = "HMAC_KEY"
          hmac_key_access_id = google_storage_hmac_key.airbyte_bq_controller.access_id
          hmac_key_secret = google_storage_hmac_key.airbyte_bq_controller.secret
        }
      }
    }
  # This is some shenanigans to appease the terraform provider
  standard_insert_count = var.loading_method == "standard-inserts" ? 1 : 0
  gcs_staging_count = var.loading_method == "gcs-staging" ? 1 : 0
}

resource "airbyte_destination_bigquery" "bigquery_destination_standard_inserts" {
  count = local.standard_insert_count
  name = var.destination_name
  workspace_id = var.airbyte_workspace_id
  configuration = {
    # Required
    dataset_id = var.dataset_info.dataset_id
    dataset_location = var.dataset_info.dataset_location
    destination_type = "bigquery"
    project_id = data.google_project.project.project_id
    # Optional
    big_query_client_buffer_size_mb = var.big_query_client_buffer_size_mb
    credentials_json = base64decode(google_service_account_key.airbyte_bq_controller.private_key)
    transformation_priority = var.transformation_priority
    loading_method = {
      destination_bigquery_update_loading_method_standard_inserts = local.standard_inserts_method
    }
  }
}

resource "airbyte_destination_bigquery" "bigquery_destination_gcs_staging" {
  count = local.gcs_staging_count
  name = var.destination_name
  workspace_id = var.airbyte_workspace_id
  configuration = {
    # Required
    dataset_id = var.dataset_info.dataset_id
    dataset_location = var.dataset_info.dataset_location
    destination_type = "bigquery"
    project_id = data.google_project.project.project_id
    # Optional
    big_query_client_buffer_size_mb = var.big_query_client_buffer_size_mb
    credentials_json = base64decode(google_service_account_key.airbyte_bq_controller.private_key)
    transformation_priority = var.transformation_priority
    loading_method = {
      destination_bigquery_update_loading_method_gcs_staging = local.gcs_staging_method
    }
  }
}
