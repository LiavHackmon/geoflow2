resource "aws_s3_bucket_notification" "geojson_notification" {
  bucket = aws_s3_bucket.geojson_bucket.id

  queue {
    queue_arn     = aws_sqs_queue.geojson_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".geojson"
  }

  depends_on = [aws_sqs_queue.geojson_queue]
}
resource "aws_sqs_queue_policy" "allow_s3" {
  queue_url = aws_sqs_queue.geojson_queue.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowS3ToSendMessage",
        Effect = "Allow",
        Principal = "*",
        Action = "sqs:SendMessage",
        Resource = aws_sqs_queue.geojson_queue.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_s3_bucket.geojson_bucket.arn
          }
        }
      }
    ]
  })
}

