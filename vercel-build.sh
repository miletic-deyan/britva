#!/bin/bash

# Exit when any command fails
set -e

echo "📦 Installing dependencies..."

# Install Composer
echo "🎼 Installing Composer..."
curl -sS https://getcomposer.org/installer | php
echo "✅ Composer installed successfully!"

# Install PHP dependencies
echo "🐘 Installing PHP dependencies..."
php composer.phar install --no-interaction --prefer-dist --optimize-autoloader
echo "✅ PHP dependencies installed successfully!"

# Clear Laravel caches
echo "🧹 Clearing Laravel caches..."
php artisan config:clear
php artisan route:clear
echo "✅ Laravel caches cleared successfully!"

# Install NPM dependencies if package.json exists
if [ -f "package.json" ]; then
    echo "📦 Installing NPM dependencies..."
    npm install
    echo "✅ NPM dependencies installed successfully!"

    # Build frontend assets if build script exists
    if grep -q "\"build\"" package.json; then
        echo "🏗️ Building frontend assets..."
        npm run build
        echo "✅ Frontend assets built successfully!"
    fi
fi

# Create storage link
echo "🔗 Creating storage link..."
php artisan storage:link
echo "✅ Storage link created successfully!"

echo "🚀 Build completed successfully!" 