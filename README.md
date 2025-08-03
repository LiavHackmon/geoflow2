
GeoJSON AWS Data Pipeline – Project Summary
This project presents a fully automated data ingestion and processing pipeline, designed and implemented using AWS infrastructure, containerization, and Infrastructure as Code (IaC). The primary goal of the pipeline is to enable seamless ingestion of GeoJSON files into a spatial database, ensuring data validation, automation, and operational robustness.

✅ Project Objectives
Provision cloud infrastructure using Terraform

Automate the ingestion and processing of GeoJSON files uploaded to Amazon S3

Validate and load spatial data into a PostgreSQL RDS instance with PostGIS extension

Containerize the application using Docker

Enable asynchronous processing using SQS-based event handling

Maintain clean project architecture with modular structure and reproducible deployment

🔧 Implementation Details
Infrastructure:

AWS RDS: PostgreSQL instance with PostGIS extension for spatial data storage

S3 Bucket: Private bucket configured to trigger events on file upload

SQS: A message queue receives events from S3 and triggers file processing

EC2 Instance: Public instance running Docker container that listens for SQS events

IAM Roles: Custom IAM roles and policies for scoped access to AWS services

ECR: Used as a private container registry for application deployment

Application Logic:

Written in Python (Flask-based service)

Listens to SQS events indicating new files in S3

Downloads and validates GeoJSON files

Inserts data into RDS using psycopg2 with PostGIS spatial functions

All logs are directed to the container’s stdout (visible in EC2 logs)

Automation:

Docker container built with necessary dependencies (e.g., boto3, psycopg2, geojson)

EC2 pulls the image from ECR automatically via user_data

The application runs continuously as an event-driven listener inside the container

Structure:

Infrastructure code split into logical modules (rds/, s3/, sqs/, iam/, ecr/, ec2/)

Python app and Dockerfile live in a separate app/ directory

Deployment is fully reproducible via a simple Makefile (make infra, make build, make deploy)

🎯 Outcomes
The result is a clean, cloud-native, event-driven pipeline that processes any new GeoJSON file uploaded to S3 without manual intervention. The project is modular, secure, reproducible, and production-ready in design. All code is version-controlled and publicly documented in GitHub.
