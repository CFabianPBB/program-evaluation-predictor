#!/usr/bin/env bash
# Exit on error
set -o errexit

# Install server dependencies
echo "Installing server dependencies..."
npm install

# Build the client
echo "Building React client..."
cd client

# Install client dependencies
echo "Installing client dependencies..."
npm install

# Build the client
echo "Running client build..."
npm run build

# Return to the root directory
cd ..

echo "Build completed successfully!"