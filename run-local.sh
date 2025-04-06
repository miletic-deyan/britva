#!/bin/bash

# Output colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print header
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}     Britva Application Launcher     ${NC}"
echo -e "${GREEN}======================================${NC}"

# Check for docker and docker-compose
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

# Stop any existing containers
echo -e "${GREEN}Stopping any existing containers...${NC}"
docker-compose down

# Build and start the containers
echo -e "${GREEN}Building and starting the application...${NC}"
docker-compose up -d

# Run migrations
echo -e "${GREEN}Running database migrations...${NC}"
docker-compose exec app php artisan migrate

# Generate app key if needed
echo -e "${GREEN}Ensuring application key is set...${NC}"
docker-compose exec app php artisan key:generate --force

# Complete
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}Application is now running!${NC}"
echo -e "${GREEN}Access it at: http://localhost:8000${NC}"
echo -e "${GREEN}To view logs: docker-compose logs -f${NC}"
echo -e "${GREEN}To stop: docker-compose down${NC}"
echo -e "${GREEN}======================================${NC}" 