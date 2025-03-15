#!/usr/bin/env bash
# Exit on error
set -o errexit

# List directories to understand the structure
echo "Listing directories in current folder:"
ls -la

# Install server dependencies
npm install

# If there's a client directory, check its contents
if [ -d "./client" ]; then
  echo "Client directory found, checking contents..."
  ls -la ./client
  
  # Check if client directory is empty or doesn't have package.json
  if [ ! -f "./client/package.json" ]; then
    echo "No package.json found in client directory. Setting up a basic React app..."
    
    # Create a basic index.html in the client directory
    mkdir -p ./client/build
    cat > ./client/build/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Program Evaluation Predictor</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        header {
            background-color: #333;
            color: white;
            padding: 20px;
            text-align: center;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        h1 {
            margin: 0;
        }
        p {
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Program Evaluation Predictor</h1>
            <p>Analyze government programs and predict evaluation scores</p>
        </header>
        <main>
            <p>Welcome to the Program Evaluation Predictor. This application is designed to help analyze government programs and predict their evaluation scores based on various factors.</p>
            <p>Please use the API endpoints to interact with the application.</p>
        </main>
    </div>
</body>
</html>
EOF
    echo "Basic index.html created in client/build directory"
  else
    echo "package.json found in client directory, building client..."
    cd client
    npm install
    
    # Try using npx react-scripts build
    npm install --save-dev react-scripts
    npx react-scripts build
    cd ..
  fi
else
  echo "No client directory found, skipping client build"
fi

echo "Build completed successfully!"