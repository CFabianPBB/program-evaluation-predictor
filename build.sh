#!/usr/bin/env bash
# Exit on error
set -o errexit

# List directories to understand the structure
echo "Listing directories in current folder:"
ls -la

# Install server dependencies
npm install

# If there's no client directory, we'll skip the client build
if [ -d "./client" ]; then
  echo "Client directory found, building client..."
  cd client
  npm install
  npm run build
  cd ..
else
  echo "No client directory found, skipping client build"
fi