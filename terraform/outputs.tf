output "rds_endpoint" {
  description = "RDS endpoint (hostname)"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.postgres.port
}

output "geojson_bucket_name" {
  value = aws_s3_bucket.geojson_bucket.bucket
  description = "Name of the S3 Bucket for GeoJSON files"
}

output "ecr_url" {
  description = "RDS port"
  value       = aws_ecr_repository.flask_app_repo.repository_url
}
