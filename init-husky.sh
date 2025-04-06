#!/bin/bash

# Make script executable: chmod +x init-husky.sh

echo "Installing Node.js dependencies..."
npm install

echo "Initializing Husky..."
npx husky install

echo "Adding Husky hooks..."
# Ensure directory exists
mkdir -p .husky

# Add commit-msg hook if it doesn't exist
if [ ! -f .husky/commit-msg ]; then
  npx husky add .husky/commit-msg "npx --no -- commitlint --edit \$1"
  chmod +x .husky/commit-msg
fi

# Add pre-commit hook if it doesn't exist
if [ ! -f .husky/pre-commit ]; then
  npx husky add .husky/pre-commit "npm run lint"
  chmod +x .husky/pre-commit
fi

echo "Husky setup complete!"
echo "Now your commits will be checked for conventional commits format."
echo "You can use 'npm run commit' to create a conventional commit." 