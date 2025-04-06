#!/bin/bash

# Exit when any command fails
set -e

echo "📦 Starting Laravel build process on Vercel..."

# Create a directory for Node.js based PHP executor
echo "🔧 Setting up Node.js PHP executor..."
mkdir -p bin

# Create a PHP wrapper script
cat > bin/php <<'EOL'
#!/usr/bin/env node

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');
const os = require('os');

// Create a temporary file with PHP code
const tmpDir = os.tmpdir();
const tmpFile = path.join(tmpDir, `vercel-php-${Date.now()}.php`);

// Get all arguments after the script name
const args = process.argv.slice(2);
let phpCode = '';

if (args.length === 0) {
  console.log("This is a Node.js wrapper for PHP in Vercel environment");
  process.exit(0);
}

// Check if we're executing a PHP file
if (args[0].endsWith('.php') && fs.existsSync(args[0])) {
  // Execute PHP file directly using the Vercel PHP runtime
  try {
    const result = execSync(`/var/task/php/bin/php ${args.join(' ')}`, { stdio: 'inherit' });
  } catch (error) {
    process.exit(error.status || 1);
  }
} else if (args[0] === '-r') {
  // Handle PHP code snippet
  phpCode = args[1];
  fs.writeFileSync(tmpFile, phpCode);
  
  try {
    const result = execSync(`/var/task/php/bin/php ${tmpFile}`, { stdio: 'inherit' });
    fs.unlinkSync(tmpFile);
  } catch (error) {
    fs.unlinkSync(tmpFile);
    process.exit(error.status || 1);
  }
} else {
  // Forward all arguments to the PHP runtime
  try {
    const result = execSync(`/var/task/php/bin/php ${args.join(' ')}`, { stdio: 'inherit' });
  } catch (error) {
    process.exit(error.status || 1);
  }
}
EOL

chmod +x bin/php
export PATH="$PWD/bin:$PATH"

echo "✅ PHP wrapper created."

# Install Composer manually
echo "🎼 Installing Composer..."
curl -sS https://getcomposer.org/installer -o composer-setup.php
bin/php composer-setup.php --quiet
rm composer-setup.php
echo "✅ Composer installed."

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
  echo "🔑 Creating .env file..."
  cp .env.example .env
  echo "✅ .env file created."
fi

# Install dependencies with --ignore-platform-reqs flag
echo "🐘 Installing PHP dependencies..."
bin/php composer.phar install --no-interaction --prefer-dist --optimize-autoloader --ignore-platform-reqs
echo "✅ Dependencies installed."

# Generate app key
echo "🔑 Generating application key..."
bin/php artisan key:generate --force
echo "✅ Application key generated."

# Build frontend assets
if [ -f "package.json" ]; then
  if grep -q "\"build\"" package.json; then
    echo "🏗️ Building frontend assets..."
    npm run build
    echo "✅ Frontend assets built."
  fi
fi

echo "🚀 Build process completed!" 