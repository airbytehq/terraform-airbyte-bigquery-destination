data "google_project" "project" {
  # While not strictly necessary, this helps ensure the project exists (or your credentials have access to it) 
  # before attempting to assign permissions
  project_id = var.gcp_project_id
}

resource "google_service_account" "airbyte_bq_controller" {
  account_id = var.service_account_id
  description = "Airbyte uses this account to Create Datasets and Tables in BigQuery and Stage objects in GCS"
  display_name = "Airbyte BigQuery Controller"
}

resource "google_service_account_key" "airbyte_bq_controller" {
  service_account_id = google_service_account.airbyte_bq_controller.name
}

resource "google_storage_hmac_key" "airbyte_bq_controller" {
  service_account_email = google_service_account.airbyte_bq_controller.email
}

resource "google_project_iam_member" "add_permissions" {
  for_each = toset(var.service_account_role_grants)
  project = data.google_project.project.project_id
  role = each.key
  member = google_service_account.airbyte_bq_controller.member
}
