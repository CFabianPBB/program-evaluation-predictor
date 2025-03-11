const express = require('express');
const fileUpload = require('express-fileupload');
const path = require('path');
const cors = require('cors');
const morgan = require('morgan');
const dotenv = require('dotenv');
const fs = require('fs');

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

// Debugging - log current directory and files
console.log('Current directory:', __dirname);
console.log('Files in current directory:', fs.readdirSync(__dirname).join(', '));

// Routes
app.use('/api', require('./routes/api'));

// Serve static files
if (process.env.NODE_ENV === 'production') {
  // First try to serve the index.html in the root
  app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
  });
  
  // Try to serve from client/build if it exists
  if (fs.existsSync(path.join(__dirname, 'client/build'))) {
    console.log('client/build directory found, serving static files');
    app.use(express.static(path.join(__dirname, 'client/build')));
  } else {
    console.log('client/build directory not found');
  }
} else {
  // In development, we serve the index.html in the root
  app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
  });
}

// Define port
const PORT = process.env.PORT || 5000;

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});