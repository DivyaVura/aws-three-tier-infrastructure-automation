# Retrieve existing RDS credentials from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = "rds/terraform/credentials"
}

# Decode the JSON secret
locals {
  db_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.rds_credentials.secret_string
  )
}