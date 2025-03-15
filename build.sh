#!/usr/bin/env bash
# Exit on error
set -o errexit

# Install server dependencies
echo "Installing server dependencies..."
npm install

# Show directory structure for debugging
echo "Directory structure:"
find . -type d -maxdepth 2 | sort

# Create client/package.json if it doesn't exist
if [ ! -f client/package.json ]; then
  echo "Creating client/package.json..."
  mkdir -p client
  cat > client/package.json << 'EOF'
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

# Create client/public directory and files if they don't exist
if [ ! -d client/public ] || [ ! -f client/public/index.html ]; then
  echo "Creating client/public directory and files..."
  mkdir -p client/public
  
  # Create index.html
  cat > client/public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta name="description" content="Program Evaluation Predictor" />
    <link rel="apple-touch-icon" href="%PUBLIC_URL%/logo192.png" />
    <link rel="manifest" href="%PUBLIC_URL%/manifest.json" />
    <title>Program Evaluation Predictor</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
EOF

  # Create manifest.json
  cat > client/public/manifest.json << 'EOF'
{
  "short_name": "Evaluation Predictor",
  "name": "Program Evaluation Predictor",
  "icons": [
    {
      "src": "favicon.ico",
      "sizes": "64x64 32x32 24x24 16x16",
      "type": "image/x-icon"
    }
  ],
  "start_url": ".",
  "display": "standalone",
  "theme_color": "#000000",
  "background_color": "#ffffff"
}
EOF

  # Create a simple favicon.ico
  echo -ne '\x00\x00\x01\x00\x01\x00\x10\x10\x00\x00\x01\x00\x18\x00h\x03\x00\x00\x16\x00\x00\x00(\x00\x00\x00\x10\x00\x00\x00 \x00\x00\x00\x01\x00\x18\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\xb6\xcc\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' > client/public/favicon.ico
fi

# Now we also need to create the src directory and files if they don't exist
if [ ! -d client/src ] || [ ! -f client/src/index.js ]; then
  echo "Creating client/src directory and files..."
  mkdir -p client/src/components
  
  # Create index.js
  cat > client/src/index.js << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import 'bootstrap/dist/css/bootstrap.min.css';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

  # Create index.css
  cat > client/src/index.css << 'EOF'
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}
EOF

  # Create App.css
  cat > client/src/App.css << 'EOF'
.app-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.app-header {
  background-color: #343a40;
  color: white;
  padding: 20px 0;
  margin-bottom: 30px;
  border-radius: 5px;
}

.app-title {
  font-size: 2rem;
  font-weight: 600;
}

.app-subtitle {
  font-size: 1rem;
  opacity: 0.8;
}

.input-section {
  background-color: white;
  border-radius: 5px;
  padding: 25px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-bottom: 30px;
}

.form-section-title {
  margin-bottom: 20px;
  color: #343a40;
  font-weight: 600;
}
EOF

  # Create App.js
  cat > client/src/App.js << 'EOF'
import React from 'react';
import { Container } from 'react-bootstrap';
import './App.css';

function App() {
  return (
    <div className="app-container">
      <header className="app-header">
        <Container>
          <h1 className="app-title">Program Evaluation Predictor</h1>
          <p className="app-subtitle">Analyze government programs and predict evaluation scores</p>
        </Container>
      </header>
      <Container>
        <div className="input-section">
          <h4 className="form-section-title">Upload Program Data</h4>
          <p>This application helps analyze government programs and predict their evaluation scores.</p>
          <p>Please use the API endpoints to interact with the application.</p>
        </div>
      </Container>
    </div>
  );
}

export default App;
EOF

  # Create Header component
  cat > client/src/components/Header.js << 'EOF'
import React from 'react';
import { Container } from 'react-bootstrap';

function Header() {
  return (
    <header className="app-header">
      <Container>
        <h1 className="app-title">Program Evaluation Predictor</h1>
        <p className="app-subtitle">Analyze government programs and predict evaluation scores</p>
      </Container>
    </header>
  );
}

export default Header;
EOF
fi

# Build the client
echo "Building React client..."
cd client

# Install client dependencies
echo "Installing client dependencies..."
npm install

# Build the client
echo "Running client build..."
CI=false npm run build

# Return to the root directory
cd ..

echo "Build completed successfully!"