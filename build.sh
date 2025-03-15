#!/usr/bin/env bash
# Exit on error
set -o errexit

# Install server dependencies
echo "Installing server dependencies..."
npm install

# Show directory structure for debugging
echo "Directory structure:"
find . -type d -maxdepth 2 | sort

# Check if client/package.json exists
if [ -f client/package.json ]; then
  echo "client/package.json exists, proceeding with build"
else
  echo "client/package.json does not exist, this is an error"
  exit 1
fi

# Build the client
echo "Building React client..."
cd client

# Check for package.json and build script
if grep -q "\"build\"" package.json; then
  echo "Build script found in package.json"
else
  echo "No build script found in package.json, this is an error"
  exit 1
fi

# Install client dependencies
echo "Installing client dependencies..."
npm install

# Build the client
echo "Running client build..."
CI=false npm run build

# Return to the root directory
cd ..

echo "Build completed successfully!"