#!/bin/bash

# Make script executable: chmod +x deploy-to-cloud.sh

echo "Laravel Cloud Deployment Helper"
echo "=============================="
echo ""
echo "This script will help you prepare your application for Laravel Cloud deployment."
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
  echo "❌ Git repository not initialized."
  echo "You need a Git repository to deploy to Laravel Cloud."
  read -p "Initialize Git repository? (y/n): " init_git
  if [[ $init_git == [yY] || $init_git == [yY][eE][sS] ]]; then
    git init
    echo "✅ Git repository initialized."
  else
    echo "Aborted. Please initialize a Git repository manually."
    exit 1
  fi
fi

# Check if there's a remote repository
remote_url=$(git config --get remote.origin.url)
if [ -z "$remote_url" ]; then
  echo "❌ No Git remote repository found."
  echo "You need to push your code to a remote repository (GitHub, GitLab, BitBucket)."
  echo "Please add a remote repository manually with:"
  echo "  git remote add origin <repository-url>"
  echo ""
fi

# Check for .env for Laravel Cloud
if grep -q "LARAVEL_CLOUD=" .env; then
  echo "✅ Laravel Cloud configuration found in .env"
else
  echo "⚠️ No Laravel Cloud configuration found in .env"
  echo "You may need to modify your environment variables after deploying to Laravel Cloud."
  echo ""
fi

# Ensure all changes are committed
git_status=$(git status --porcelain)
if [ -n "$git_status" ]; then
  echo "⚠️ You have uncommitted changes."
  git status
  read -p "Commit all changes with message 'Prepare for Laravel Cloud deployment'? (y/n): " commit_changes
  if [[ $commit_changes == [yY] || $commit_changes == [yY][eE][sS] ]]; then
    git add .
    git commit -m "build: prepare for Laravel Cloud deployment"
    echo "✅ Changes committed."
  else
    echo "Please commit your changes manually before deploying."
  fi
fi

# Provide information about Laravel Cloud
echo ""
echo "Next Steps for Laravel Cloud Deployment:"
echo "----------------------------------------"
echo "1. Sign up or log in to Laravel Cloud: https://cloud.laravel.com/"
echo "2. Click 'New Application' and connect your Git provider"
echo "3. Select this repository and configure your deployment settings"
echo "4. Deploy your application"
echo ""
echo "For detailed instructions, refer to LARAVEL_CLOUD_DEPLOYMENT.md"
echo ""

# Ask if user wants to push changes
if [ -n "$remote_url" ]; then
  read -p "Push latest changes to remote repository? (y/n): " push_changes
  if [[ $push_changes == [yY] || $push_changes == [yY][eE][sS] ]]; then
    echo "Pushing changes to remote repository..."
    current_branch=$(git symbolic-ref --short HEAD)
    git push origin $current_branch
    echo "✅ Changes pushed to $current_branch"
  fi
fi

echo ""
echo "Your application is now ready for Laravel Cloud deployment!"
echo "Visit https://cloud.laravel.com/ to complete the deployment." 