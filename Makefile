# Makefile

export ECR_URL=$(shell terraform -chdir=terraform output -raw ecr_url)

infra:
	cd terraform && terraform apply -target=aws_ecr_repository.flask_app_repo -auto-approve

build:
	aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin $(ECR_URL)
	cd app && docker build -t flask-app-repo .
	docker tag flask-app-repo:latest $(ECR_URL):latest
	docker push $(ECR_URL):latest

deploy:
	cd terraform && terraform apply -auto-approve

