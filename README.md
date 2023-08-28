# Setup a BigQuery Destination in Airbyte
This module will create everything needed to set up a BigQuery destination. This includes:

- A Google Service Account for accessing BigQuery and GCS data
- Credentials for that service account
- A BigQuery destination in [Airbyte Cloud](https://airbyte.com/solutions/airbyte-cloud) or [Airbyte OSS](https://airbyte.com/oss-vs-cloud-vs-enterprise) to be in used in [Connections](https://docs.airbyte.com/understanding-airbyte/connections/)

There are two different loading methods for BigQuery, Standard inserts or GCS Staging. GCS staging is more performant and the method Airbyte recommends, so this module defaults to GCS Staging.

See the `./examples` directory for examples to both create a new dataset or use an existing one.
