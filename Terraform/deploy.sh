#!/bin/bash
set -e

REGION="${region}"
ECR_REPO="${repository_url}"
CONTAINER_NAME="my-devOps-app"
PORT=${app_port}

# github build_tag
TAG=$(/usr/bin/aws ssm get-parameter \
  --name "${image_tags_name}" \
  --query "Parameter.Value" \
  --output text)

echo "Deploying version: $TAG"

# Login to ECR
aws ecr get-login-password --region $REGION \
| docker login --username AWS --password-stdin $ECR_REPO

# Pull latest image
docker pull $ECR_REPO:$TAG

# Check running container
if docker ps -q -f name=$CONTAINER_NAME; then
  echo "Stopping old container..."
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
fi

# Run new container
docker run -d \
  --name $CONTAINER_NAME \
  --restart unless-stopped \
  -p $PORT:$PORT \
  $ECR_REPO:$TAG
