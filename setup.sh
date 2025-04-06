#!/bin/bash

# Make script executable: chmod +x setup.sh

# Create a temporary directory for Laravel installation
echo "Setting up Laravel project..."
docker-compose exec app mkdir -p /tmp/laravel-temp

# Install Laravel in a temporary location
echo "Installing Laravel in temporary location..."
docker-compose exec app composer create-project --prefer-dist laravel/laravel /tmp/laravel-temp

# Copy Laravel files to the main directory
echo "Copying Laravel files to the main directory..."
docker-compose exec app sh -c "cp -R /tmp/laravel-temp/. /var/www/ && rm -rf /tmp/laravel-temp"

# Set proper permissions
echo "Setting proper permissions..."
docker-compose exec app chown -R www:www /var/www

# Generate application key
echo "Generating application key..."
docker-compose exec app php artisan key:generate

# Run migrations
echo "Running migrations..."
docker-compose exec app php artisan migrate

echo "Setup complete! Your Laravel application is now ready."
echo "Access it at: http://localhost:8000" 