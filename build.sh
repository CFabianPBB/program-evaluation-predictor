#!/usr/bin/env bash
# Exit on error
set -o errexit

# Install dependencies for the server
npm install

# Navigate to client directory
cd client

# Install dependencies for the client
npm install

# Run the React build directly using react-scripts
npx react-scripts build

# Return to root directory
cd ..