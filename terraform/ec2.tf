resource "aws_instance" "app_server" {
  ami                    = "ami-0b6acaa45fec15278" # Amazon Linux 2023 (eu-north-1)
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
              echo "=== Starting user_data script ==="

              dnf update -y
              dnf install -y docker

              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user

              echo "Waiting for Docker..."
              timeout 120 bash -c 'until docker info >/dev/null 2>&1; do sleep 3; done'

              echo "Logging into ECR..."
              aws ecr get-login-password --region ${var.aws_region} | \
              docker login --username AWS --password-stdin ${aws_ecr_repository.flask_app_repo.repository_url}

              echo "Pulling image..."
              docker pull ${aws_ecr_repository.flask_app_repo.repository_url}:latest

              echo "Running container..."
              docker run -d --env S3_BUCKET_NAME=${aws_s3_bucket.geojson_bucket.bucket} \
                           --env S3_OBJECT_KEY=example.geojson \
                           --env RDS_HOST=${aws_db_instance.postgres.endpoint} \
                           --env RDS_PORT=${var.rds_port} \
                           --env RDS_USER=${var.rds_user} \
                           --env RDS_PASSWORD=${var.rds_password} \
                           --env RDS_DB=${var.rds_db} \
                           ${aws_ecr_repository.flask_app_repo.repository_url}:latest

              echo "=== user_data script completed ==="
              EOF

  tags = {
    Name = "flask-app-server"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.flask_role.name
}

