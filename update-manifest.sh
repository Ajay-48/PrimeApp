#!/bin/bash

# Define variables
DEPLOYMENT_FILE="./k8s_files/deployment.yaml"     # Path to your deployment YAML file
IMAGE_NAME="ajay048/primeapp"           # Your Docker image name (without the tag)

# Update the image tag in the deployment file using sed
sed -i "s|image: ${IMAGE_NAME}:.*|image: ${IMAGE_NAME}:${BUILD_NUMBER}|" "$DEPLOYMENT_FILE"


# Check if the operation was successful
if [ $? -eq 0 ]; then
  echo "Successfully updated the image tag to ${BUILD_NUMBER} in the deployment file."
else
  echo "Failed to update the image tag."
  exit 1
fi
