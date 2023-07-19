output bigquery_destination_gcs_staging {
  value = airbyte_destination_bigquery.bigquery_destination_gcs_staging
}

output "bigquery_destination_standard_inserts" {
  value = airbyte_destination_bigquery.bigquery_destination_standard_inserts
}

output "airbyte_service_account" {
  value = google_service_account.airbyte_bq_controller
}
