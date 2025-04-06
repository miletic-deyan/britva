#!/bin/bash

# Make script executable: chmod +x clean.sh

echo "This script will stop all containers and clean the Laravel environment."
echo "Warning: This will remove all project files except Docker configuration."
read -p "Are you sure you want to proceed? (y/n): " confirm

if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
  # Stop the containers
  echo "Stopping Docker containers..."
  docker-compose down
  
  # Remove Laravel files but keep Docker configuration
  echo "Removing Laravel files..."
  find . -type f -not -path "*/\.*" -not -name "docker-compose.yml" \
    -not -name "Dockerfile" -not -name "*.sh" -not -name "README.md" \
    -not -path "./docker/*" -delete
  
  find . -type d -empty -not -path "*/\.*" -not -path "./docker*" -delete
  
  echo "Environment cleaned. You can restart the setup with:"
  echo "  1. docker-compose up -d"
  echo "  2. ./setup.sh"
else
  echo "Operation cancelled."
fi 