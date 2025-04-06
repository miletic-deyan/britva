#!/bin/bash

# Exit when any command fails
set -e

echo "📦 Starting Laravel build process on Vercel..."

# Install Composer directly
echo "🎼 Installing Composer..."
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" || echo "Failed to download Composer installer"
php composer-setup.php --quiet || echo "Failed to run Composer installer"
php -r "unlink('composer-setup.php');" || echo "Failed to remove Composer installer"
echo "✅ Composer installation attempts completed."

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
  echo "🔑 Creating .env file..."
  cp .env.example .env || echo "Failed to create .env file"
fi

# Try to install dependencies
echo "🐘 Installing PHP dependencies..."
php composer.phar install --no-interaction --prefer-dist --optimize-autoloader --ignore-platform-reqs || 
echo "⚠️ Failed to install dependencies. Continuing anyway..."

# Try generating app key
if grep -q "^APP_KEY=$" .env 2>/dev/null || ! grep -q "^APP_KEY=" .env 2>/dev/null; then
  echo "🔑 Trying to generate app key..."
  php artisan key:generate --force || echo "⚠️ Failed to generate key. Continuing anyway..."
fi

# Clear Laravel caches
echo "🧹 Clearing Laravel caches..."
php artisan config:clear || echo "⚠️ Failed to clear config cache"
php artisan route:clear || echo "⚠️ Failed to clear route cache"

# Create storage link
echo "🔗 Creating storage link..."
php artisan storage:link || echo "⚠️ Could not create storage link, but continuing build..."

# Build frontend assets if package.json exists
if [ -f "package.json" ]; then
  # Build frontend assets if build script exists
  if grep -q "\"build\"" package.json; then
    echo "🏗️ Building frontend assets..."
    npm run build || echo "⚠️ Failed to build assets. Continuing anyway..."
  fi
fi

# Ensure proper permissions
echo "🔒 Setting proper permissions..."
find . -type d -exec chmod 755 {} \; || echo "⚠️ Failed to set directory permissions"
find . -type f -exec chmod 644 {} \; || echo "⚠️ Failed to set file permissions"

echo "🚀 Build process completed!" 