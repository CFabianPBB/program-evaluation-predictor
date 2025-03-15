#!/usr/bin/env bash
# Exit on error
set -o errexit

# Install server dependencies
echo "Installing server dependencies..."
npm install

# Show what's in the client directory to debug
echo "Listing contents of client directory..."
ls -la client/

# Build the client
echo "Building React client..."
cd client

# Check if package.json exists and has the build script
if [ ! -f "package.json" ] || ! grep -q "\"build\"" package.json; then
  echo "Creating or updating package.json in client directory..."
  cat > package.json << 'EOF'
{
  "name": "program-evaluation-predictor-client",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "@testing-library/jest-dom": "^5.17.0",
    "@testing-library/react": "^13.4.0",
    "@testing-library/user-event": "^13.5.0",
    "axios": "^1.6.2",
    "bootstrap": "^5.3.2",
    "file-saver": "^2.0.5",
    "react": "^18.2.0",
    "react-bootstrap": "^2.9.1",
    "react-dom": "^18.2.0",
    "react-icons": "^4.12.0",
    "react-scripts": "5.0.1",
    "web-vitals": "^2.1.4",
    "xlsx": "^0.18.5"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
EOF
fi

# Install client dependencies
echo "Installing client dependencies..."
npm install

# Build the client
echo "Running client build..."
npm run build

# Return to the root directory
cd ..

echo "Build completed successfully!"