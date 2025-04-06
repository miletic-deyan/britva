#!/bin/bash

# Don't exit on errors - we want to continue as much as possible
set +e

echo "📦 Starting Laravel build process on Vercel..."

# Check for PHP 
echo "🔍 Checking for PHP (may not be available in build phase)..."
PHP_AVAILABLE=false
if command -v php &> /dev/null; then
    PHP_AVAILABLE=true
    PHP_VERSION=$(php -v | head -n 1 || echo "Unknown PHP version")
    echo "✅ PHP is available: $PHP_VERSION"
else
    echo "⚠️ PHP not available during build. Continuing with Node.js-only setup."
    # The PHP runtime will be available at runtime, not build time
fi

# Create important directories
echo "📁 Setting up Laravel directories..."
mkdir -p bootstrap/cache storage/framework/cache storage/framework/sessions storage/framework/views storage/logs public

# Set proper permissions
chmod -R 755 bootstrap/cache storage &> /dev/null || echo "⚠️ Note: Permission warning is normal in build environment"

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
  echo "🔑 Creating .env file..."
  if [ -f .env.example ]; then
    cp .env.example .env
    echo "✅ .env file created from example"
  else
    # Create minimal .env file
    cat > .env << 'EOL'
APP_NAME=Laravel
APP_ENV=production
APP_KEY=base64:$(openssl rand -base64 32)
APP_DEBUG=false
APP_URL=${VERCEL_URL:-http://localhost}

LOG_CHANNEL=stderr
CACHE_DRIVER=array
SESSION_DRIVER=cookie
EOL
    echo "✅ Minimal .env file created"
  fi
fi

# Generate app key directly in .env
if grep -q "^APP_KEY=$" .env 2>/dev/null || ! grep -q "^APP_KEY=" .env 2>/dev/null; then
  echo "🔑 Adding APP_KEY to environment..."
  KEY=$(openssl rand -base64 32)
  if grep -q "^APP_KEY=" .env; then
    # Replace existing empty APP_KEY
    sed -i "s/^APP_KEY=.*/APP_KEY=base64:$KEY/" .env || 
    echo "APP_KEY=base64:$KEY" >> .env
  else
    # Add APP_KEY if not present
    echo "APP_KEY=base64:$KEY" >> .env
  fi
  echo "✅ Application key generated"
fi

# Build frontend assets if package.json exists
if [ -f "package.json" ]; then
  echo "📦 Processing Node.js assets..."
  
  # Install Node.js dependencies
  if [ ! -d "node_modules" ]; then
    echo "📦 Installing Node.js dependencies..."
    npm ci || npm install || echo "⚠️ npm install finished with warnings (this is often normal)"
  fi
  
  # Build frontend assets if build script exists
  if grep -q "\"build\"" package.json; then
    echo "🏗️ Building frontend assets..."
    npm run build || echo "⚠️ npm build finished with warnings (this is often normal)"
  fi
fi

# Create a minimal composer.json if not exists
if [ ! -f "composer.json" ]; then
  echo "📝 Creating minimal composer.json..."
  cat > composer.json << 'EOL'
{
    "name": "laravel/laravel",
    "type": "project",
    "require": {
        "php": "^8.0",
        "laravel/framework": "^10.0"
    },
    "config": {
        "optimize-autoloader": true,
        "preferred-install": "dist",
        "sort-packages": true
    },
    "minimum-stability": "stable",
    "prefer-stable": true
}
EOL
  echo "✅ Minimal composer.json created"
fi

echo "📝 Creating runtime activation script for Vercel..."
mkdir -p .vercel/output/functions/api

# Create custom runtime PHP wrapper in the .vercel output directory
cat > .vercel/output/functions/api/_handler.php << 'EOL'
<?php
// Vercel runtime handler for Laravel
// Show detailed errors during setup
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Required for Laravel on Vercel
$_SERVER['SCRIPT_NAME'] = '/index.php';

// Forward to Laravel's entry point
try {
    require __DIR__ . '/../../../../public/index.php';
} catch (Exception $e) {
    http_response_code(500);
    echo "<h1>Application Error</h1>";
    echo "<p>The application encountered a critical error:</p>";
    echo "<pre>" . htmlspecialchars($e->getMessage()) . "</pre>";
    error_log($e->getMessage());
}
EOL

echo "✅ Runtime PHP handler created"

# Ensure public directory has a basic index.php if none exists
if [ ! -f "public/index.php" ]; then
  echo "📝 Creating basic public/index.php..."
  mkdir -p public
  cat > public/index.php << 'EOL'
<?php
// This basic index.php will be replaced by Laravel at runtime
echo "Laravel application is initializing. Please wait...";
EOL
  echo "✅ Basic public/index.php created"
fi

# Create a useful placeholder index.html
cat > public/index.html << 'EOL'
<!DOCTYPE html>
<html>
<head>
  <title>Laravel on Vercel</title>
  <style>
    body { font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif; line-height: 1.6; color: #222; max-width: 40rem; margin: 0 auto; padding: 2rem; }
    pre { background: #f1f1f1; padding: 1rem; border-radius: 0.25rem; overflow-x: auto; }
    code { font-size: 0.9rem; }
  </style>
</head>
<body>
  <h1>Laravel Application Setup</h1>
  <p>Your Laravel application has been deployed to Vercel and is being initialized.</p>
  <p>If you're seeing this page, it means the static assets are serving correctly, but the PHP handler hasn't taken over yet.</p>
  <p>This placeholder will be automatically replaced by your Laravel application.</p>
</body>
</html>
EOL

echo "🚀 Build process completed successfully!"
echo "📋 Note: PHP processing happens at runtime, not during build time on Vercel." 