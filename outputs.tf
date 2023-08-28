output bigquery_destination_gcs_staging {
  value = airbyte_destination_bigquery.bigquery_destination_gcs_staging
  description = "The resulting configureation of the GCS Staging BigQuery Destination, this actually returns an single element array so access it with the `[0] array indexing"
}

output "bigquery_destination_standard_inserts" {
  value = airbyte_destination_bigquery.bigquery_destination_standard_inserts
  description = "The resulting configureation of the Standard Inserts BigQuery Destination, this actually returns an single element array so access it with the `[0] array indexing"
}

output "airbyte_service_account" {
  value = google_service_account.airbyte_bq_controller
  description = "The service account created by the module which will be used for BigQuery and GCS operations"
}
