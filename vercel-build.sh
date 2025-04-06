#!/bin/bash

# Exit when any command fails
set -e

echo "📦 Starting Laravel build process on Vercel..."

# Verify PHP is available (should be provided by vercel-php runtime)
echo "🔍 Checking PHP version..."
php -v

# Install Composer
echo "🎼 Installing Composer..."
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --quiet
php -r "unlink('composer-setup.php');"
echo "✅ Composer installed successfully!"

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
  echo "🔑 Creating .env file..."
  cp .env.example .env
  echo "✅ .env file created!"
fi

# Install PHP dependencies
echo "🐘 Installing PHP dependencies..."
php composer.phar install --no-interaction --prefer-dist --optimize-autoloader
echo "✅ PHP dependencies installed successfully!"

# Generate app key if not set
if grep -q "^APP_KEY=$" .env || ! grep -q "^APP_KEY=" .env; then
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
php artisan storage:link || echo "⚠️ Could not create storage link, but continuing build..."

# Ensure proper permissions for Vercel
echo "🔒 Setting proper permissions..."
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;

echo "🚀 Build completed successfully!" 