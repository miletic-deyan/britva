#!/bin/bash

# Make script executable: chmod +x deploy-to-vercel.sh

echo "Vercel Deployment Helper for Laravel"
echo "===================================="
echo ""

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
  echo "❌ Vercel CLI not found."
  read -p "Would you like to install Vercel CLI? (y/n): " install_vercel
  if [[ $install_vercel == [yY] || $install_vercel == [yY][eE][sS] ]]; then
    echo "Installing Vercel CLI..."
    npm install -g vercel
    echo "✅ Vercel CLI installed."
  else
    echo "Aborted. Please install Vercel CLI manually."
    exit 1
  fi
fi

# Ensure files are ready for deployment
echo "Preparing files for deployment..."

# Check if vercel.json exists
if [ -f vercel.json ]; then
  echo "✅ vercel.json found."
else
  echo "❌ vercel.json not found. Please create it first."
  exit 1
fi

# Check if api/index.php exists
if [ -f api/index.php ]; then
  echo "✅ api/index.php found."
else
  echo "❌ api/index.php not found. Please create it first."
  exit 1
fi

# Check if all changes are committed
git_status=$(git status --porcelain)
if [ -n "$git_status" ]; then
  echo "⚠️ You have uncommitted changes."
  git status
  read -p "Commit all changes with message 'prepare for Vercel deployment'? (y/n): " commit_changes
  if [[ $commit_changes == [yY] || $commit_changes == [yY][eE][sS] ]]; then
    git add .
    git commit -m "build: prepare for Vercel deployment"
    echo "✅ Changes committed."
  else
    echo "Please commit your changes manually before deploying."
  fi
fi

# Deploy options
echo ""
echo "Deployment Options:"
echo "1. Deploy with default settings"
echo "2. Deploy with custom settings"
echo "3. Link to existing project"
echo "4. Exit"
read -p "Please select an option (1-4): " deploy_option

case $deploy_option in
  1)
    echo "Deploying to Vercel with default settings..."
    vercel --prod
    ;;
  2)
    echo "Deploying to Vercel with custom settings..."
    vercel
    ;;
  3)
    echo "Linking to existing Vercel project..."
    vercel link
    read -p "Would you like to deploy now? (y/n): " deploy_now
    if [[ $deploy_now == [yY] || $deploy_now == [yY][eE][sS] ]]; then
      vercel --prod
    fi
    ;;
  4)
    echo "Exiting..."
    exit 0
    ;;
  *)
    echo "Invalid option. Exiting..."
    exit 1
    ;;
esac

echo ""
echo "Note: You can set environment variables in the Vercel dashboard."
echo "Visit: https://vercel.com/dashboard"
echo ""
echo "For more information about Laravel on Vercel, visit:"
echo "https://vercel.com/guides/deploying-laravel-with-vercel" 