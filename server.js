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

// Add response sanitization middleware
app.use((req, res, next) => {
  // Store the original json method
  const originalJson = res.json;
  
  // Override the json method
  res.json = function(data) {
    // If data contains results array, sanitize it
    if (data && data.results && Array.isArray(data.results)) {
      data.results = data.results.map(program => {
        if (program) {
          // Ensure Total Cost is never undefined
          return {
            ...program,
            ' Total Cost ': program[' Total Cost '] !== undefined ? program[' Total Cost '] : 0
          };
        }
        return program;
      });
    }
    
    // Call the original json method with sanitized data
    return originalJson.call(this, data);
  };
  
  next();
});

// Routes
app.use('/api', require('./routes/api'));

// Serve static files from React build in production
if (process.env.NODE_ENV === 'production') {
  // Set static folder with more explicit path
  app.use(express.static(path.join(__dirname, 'client/build')));
  
  // For any route that's not an API route, serve the React app
  app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, 'client', 'build', 'index.html'));
  });
}

// Define port
const PORT = process.env.PORT || 5001;

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});