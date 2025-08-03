resource "aws_iam_policy" "flask_policy" {
  name        = "flask-app-policy"
  description = "Allow EC2 to access S3, ECR, SQS, and write to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.geojson_bucket.arn,
          "${aws_s3_bucket.geojson_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ],
        Resource = aws_sqs_queue.geojson_queue.arn
      }
    ]
  })
}

resource "aws_iam_role" "flask_role" {
  name = "flask-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "Flask EC2 Role"
  }
}

resource "aws_iam_role_policy_attachment" "flask_attach" {
  role       = aws_iam_role.flask_role.name
  policy_arn = aws_iam_policy.flask_policy.arn
}

