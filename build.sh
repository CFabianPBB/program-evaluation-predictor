#!/usr/bin/env bash
# Exit on error
set -o errexit

# Install dependencies
npm install

# Go to client directory
cd client

# Install client dependencies
npm install

# Build the client
npm run build

# Return to root directory
cd ..