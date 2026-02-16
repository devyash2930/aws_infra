# AWS Workshop Infrastructure

## Services
- ECS Fargate
- ECR
- Lambda
- Load Balancer
- IAM
- CloudWatch

## Deploy

cd terraform
terraform init
terraform apply

## Build & Push Docker Image

cd docker
./build.sh

## Destroy

terraform destroy
