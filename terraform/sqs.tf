resource "aws_sqs_queue" "geojson_queue" {
  name                      = "geojson-file-queue"
  visibility_timeout_seconds = 300
}

output "sqs_queue_url" {
  value = aws_sqs_queue.geojson_queue.id
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.geojson_queue.arn
}

