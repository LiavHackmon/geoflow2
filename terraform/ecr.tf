resource "aws_ecr_repository" "flask_app_repo" {
  name         = "flask-app-repo"
  force_delete = true
}

