#!/usr/bin/env bash
# Exit on error
set -o errexit

# List directories to understand the structure
echo "Listing directories in current folder:"
ls -la

# Install server dependencies
npm install

# If there's a client directory, build the client
if [ -d "./client" ]; then
  echo "Client directory found, building client..."
  cd client
  
  # Install client dependencies
  npm install
  
  # Check if there's a build script in the client's package.json
  if grep -q "\"build\"" package.json; then
    echo "Build script found, running npm run build..."
    npm run build
  else
    echo "No build script found, using react-scripts directly..."
    echo "Listing available scripts in client's package.json:"
    grep "\"scripts\"" package.json -A 10
    
    # Install react-scripts if not already installed
    npm install --save-dev react-scripts
    
    # Run build directly with npx
    npx react-scripts build
  fi
  
  cd ..
else
  echo "No client directory found, skipping client build"
fi