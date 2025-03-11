const express = require('express');
const fileUpload = require('express-fileupload');
const path = require('path');
const cors = require('cors');
const morgan = require('morgan');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config();

// Initialize Express app
const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));
app.use(fileUpload({
  createParentPath: true,
  limits: { 
    fileSize: 10 * 1024 * 1024 // 10MB max file size
  },
  abortOnLimit: true,
  useTempFiles: true,
  tempFileDir: '/tmp/'
}));

// Routes
app.use('/api', require('./routes/api'));

// Serve static files from React build in production
if (process.env.NODE_ENV === 'production') {
  const fs = require('fs');
  
  // Define all possible paths where build files might be
  const possiblePaths = [
    path.join(__dirname, './client/build'),
    path.join(__dirname, 'client/build'),
    path.join(__dirname, '../client/build'),
    path.join(__dirname, 'build'),
    '/opt/render/project/src/client/build'
  ];
  
  console.log('Current directory:', __dirname);
  console.log('Looking for build directory in:');
  
  // Find the first valid path
  let validPath = null;
  for (const testPath of possiblePaths) {
    console.log(` - ${testPath}: ${fs.existsSync(testPath) ? 'EXISTS' : 'NOT FOUND'}`);
    if (fs.existsSync(testPath)) {
      validPath = testPath;
      break;
    }
  }
  
  if (validPath) {
    console.log(`Found build directory at: ${validPath}`);
    app.use(express.static(validPath));
    
    app.get('*', (req, res) => {
      const indexPath = path.join(validPath, 'index.html');
      if (fs.existsSync(indexPath)) {
        res.sendFile(indexPath);
      } else {
        res.status(404).send('index.html not found');
      }
    });
  } else {
    console.error('Could not find client build directory');
    app.get('*', (req, res) => {
      res.status(404).send('Build directory not found. The app may not be properly built.');
    });
  }
}

// Define port
const PORT = process.env.PORT || 5000;

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});