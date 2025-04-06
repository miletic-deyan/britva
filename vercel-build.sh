#!/bin/bash

# Exit when any command fails
set -e

echo "📦 Starting Laravel build process on Vercel..."

# Install PHP
echo "🔧 Installing PHP..."
mkdir -p "$HOME/php"
curl -L https://github.com/vercel-community/php/releases/download/php-8.2.9/php-8.2.9-linux-x64-build.tar.gz | tar -xz -C "$HOME/php"
export PATH="$HOME/php/bin:$PATH"
php -v
echo "✅ PHP installed successfully!"

# Install Composer
echo "🎼 Installing Composer..."
curl -sS https://getcomposer.org/installer | php
echo "✅ Composer installed successfully!"

# Install PHP dependencies
echo "🐘 Installing PHP dependencies..."
php composer.phar install --no-interaction --prefer-dist --optimize-autoloader
echo "✅ PHP dependencies installed successfully!"

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
  echo "🔑 Creating .env file..."
  cp .env.example .env
  echo "✅ .env file created!"
fi

# Generate app key if not set
if ! grep -q "^APP_KEY=" .env || grep -q "^APP_KEY=$" .env; then
  echo "🔑 Generating app key..."
  php artisan key:generate --force
  echo "✅ App key generated!"
fi

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