#!/bin/bash

# Deployment script for Python Exchange Rate App
# This script can be run on the EC2 instance for manual deployment

set -e

# Configuration
ECR_REGISTRY="<account-id>.dkr.ecr.us-east-1.amazonaws.com"
ECR_REPOSITORY="python-exchange-app"
CONTAINER_NAME="python-app"
HOST_PORT="80"
CONTAINER_PORT="5000"

echo "Starting deployment..."

# Login to ECR
echo "Logging into ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_REGISTRY

# Stop and remove existing container
echo "Stopping existing container..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Pull latest image
echo "Pulling latest image..."
docker pull $ECR_REGISTRY/$ECR_REPOSITORY:latest

# Run new container
echo "Starting new container..."
docker run -d \
  --name $CONTAINER_NAME \
  -p $HOST_PORT:$CONTAINER_PORT \
  --restart unless-stopped \
  $ECR_REGISTRY/$ECR_REPOSITORY:latest

echo "Deployment completed successfully!"
echo "Application is running on port $HOST_PORT"