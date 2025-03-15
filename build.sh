#!/usr/bin/env bash
# Exit on error
set -o errexit

# Install server dependencies
echo "Installing server dependencies..."
npm install

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
mkdir -p client/public
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

# Create necessary directories
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

.file-upload-container {
  border: 2px dashed #ced4da;
  border-radius: 5px;
  padding: 30px;
  text-align: center;
  margin-bottom: 20px;
  background-color: #f8f9fa;
  transition: all 0.3s ease;
  cursor: pointer;
}

.file-upload-container:hover {
  border-color: #007bff;
  background-color: #e9ecef;
}

.file-upload-container.active {
  border-color: #28a745;
  background-color: #d4edda;
}
EOF

# Create App.js
cat > client/src/App.js << 'EOF'
import React, { useState } from 'react';
import { Container, Row, Col } from 'react-bootstrap';
import Header from './components/Header';
import FileUpload from './components/FileUpload';
import UrlInput from './components/UrlInput';
import Results from './components/Results';
import axios from 'axios';
import './App.css';

function App() {
  const [file, setFile] = useState(null);
  const [websiteUrl, setWebsiteUrl] = useState('');
  const [costThreshold, setCostThreshold] = useState('');
  const [results, setResults] = useState(null);
  const [resultFile, setResultFile] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleFileChange = (selectedFile) => {
    setFile(selectedFile);
    // Reset results when a new file is selected
    setResults(null);
    setResultFile(null);
    setError(null);
  };

  const handleUrlChange = (url) => {
    setWebsiteUrl(url);
  };

  const handleThresholdChange = (threshold) => {
    setCostThreshold(threshold);
  };

  const handleSubmit = async () => {
    // Validate inputs
    if (!file) {
      setError('Please upload an Excel file');
      return;
    }

    if (!websiteUrl) {
      setError('Please enter a website URL');
      return;
    }

    if (!costThreshold || isNaN(parseFloat(costThreshold))) {
      setError('Please enter a valid cost threshold');
      return;
    }

    setLoading(true);
    setError(null);

    try {
      // Create form data
      const formData = new FormData();
      formData.append('file', file);
      formData.append('websiteUrl', websiteUrl);
      formData.append('costThreshold', costThreshold);

      // Send request to API
      const response = await axios.post('/api/analyze', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });

      // Update state with results
      setResults(response.data.results);
      setResultFile(response.data.resultFile);
    } catch (err) {
      setError(err.response?.data?.error || 'An error occurred during analysis');
      console.error('Analysis error:', err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="app-container">
      <Header />
      <Container>
        <Row>
          <Col lg={12}>
            <div className="input-section">
              <h4 className="form-section-title">Upload Program Data</h4>
              <FileUpload onFileChange={handleFileChange} />
              <UrlInput 
                websiteUrl={websiteUrl} 
                costThreshold={costThreshold} 
                onUrlChange={handleUrlChange} 
                onThresholdChange={handleThresholdChange}
                onSubmit={handleSubmit}
                loading={loading}
              />
              {error && <div className="alert alert-danger mt-3">{error}</div>}
            </div>
          </Col>
        </Row>
        
        {(loading || results) && (
          <Row>
            <Col lg={12}>
              <Results loading={loading} results={results} resultFile={resultFile} />
            </Col>
          </Row>
        )}
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

# Create FileUpload component
cat > client/src/components/FileUpload.js << 'EOF'
import React, { useState, useRef } from 'react';

function FileUpload({ onFileChange }) {
  const [fileName, setFileName] = useState('');
  const [isDragActive, setIsDragActive] = useState(false);
  const fileInputRef = useRef(null);

  const handleFileChange = (event) => {
    const file = event.target.files[0];
    if (file) {
      setFileName(file.name);
      onFileChange(file);
    }
  };

  const handleDragEnter = (e) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragActive(true);
  };

  const handleDragLeave = (e) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragActive(false);
  };

  const handleDragOver = (e) => {
    e.preventDefault();
    e.stopPropagation();
  };

  const handleDrop = (e) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragActive(false);
    
    const file = e.dataTransfer.files[0];
    if (file) {
      setFileName(file.name);
      onFileChange(file);
    }
  };

  const handleClick = () => {
    fileInputRef.current.click();
  };

  return (
    <div
      className={`file-upload-container ${isDragActive ? 'active' : ''}`}
      onDragEnter={handleDragEnter}
      onDragLeave={handleDragLeave}
      onDragOver={handleDragOver}
      onDrop={handleDrop}
      onClick={handleClick}
    >
      <input
        type="file"
        ref={fileInputRef}
        onChange={handleFileChange}
        style={{ display: 'none' }}
        accept=".xlsx,.xls"
      />
      {fileName ? (
        <div>
          <div className="text-success mb-2">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
              <polyline points="22 4 12 14.01 9 11.01"></polyline>
            </svg>
          </div>
          <p><strong>File Selected:</strong></p>
          <p>{fileName}</p>
          <p className="text-muted small">Click to change file</p>
        </div>
      ) : (
        <div>
          <div className="text-primary mb-2">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
              <polyline points="17 8 12 3 7 8"></polyline>
              <line x1="12" y1="3" x2="12" y2="15"></line>
            </svg>
          </div>
          <p>Drop your Excel file here or click to browse</p>
          <p className="text-muted small">.xlsx or .xls formats accepted</p>
        </div>
      )}
    </div>
  );
}

export default FileUpload;
EOF

# Create UrlInput component
cat > client/src/components/UrlInput.js << 'EOF'
import React from 'react';
import { Form, Button, InputGroup } from 'react-bootstrap';

function UrlInput({ 
  websiteUrl, 
  costThreshold, 
  onUrlChange, 
  onThresholdChange, 
  onSubmit,
  loading
}) {
  return (
    <div>
      <Form.Group className="mb-3">
        <Form.Label>Government Website URL</Form.Label>
        <InputGroup>
          <InputGroup.Text>
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
              <path d="M8 0C3.58 0 0 3.58 0 8c0 4.42 3.58 8 8 8s8-3.58 8-8c0-4.42-3.58-8-8-8zm0 14.5a6.5 6.5 0 1 1 0-13 6.5 6.5 0 0 1 0 13z"/>
              <path d="M8 13a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-9a4 4 0 1 0 0 8 4 4 0 0 0 0-8z"/>
            </svg>
          </InputGroup.Text>
          <Form.Control
            type="url"
            placeholder="https://www.tfid.org/"
            value={websiteUrl}
            onChange={(e) => onUrlChange(e.target.value)}
          />
        </InputGroup>
        <Form.Text className="text-muted">
          This helps provide context for program evaluation.
        </Form.Text>
      </Form.Group>

      <Form.Group className="mb-3">
        <Form.Label>Cost Threshold</Form.Label>
        <InputGroup>
          <InputGroup.Text>$</InputGroup.Text>
          <Form.Control
            type="number"
            placeholder="100000"
            value={costThreshold}
            onChange={(e) => onThresholdChange(e.target.value)}
          />
        </InputGroup>
        <Form.Text className="text-muted">
          Programs with costs higher than this threshold will be marked as "High Cost".
        </Form.Text>
      </Form.Group>

      <Button 
        variant="primary" 
        onClick={onSubmit}
        disabled={loading}
        className="w-100"
      >
        {loading ? 'Analyzing Programs...' : 'Analyze Programs'}
      </Button>
    </div>
  );
}

export default UrlInput;
EOF

# Create Results component
cat > client/src/components/Results.js << 'EOF'
import React from 'react';
import { Spinner, Table, Badge, Button } from 'react-bootstrap';
import { saveAs } from 'file-saver';

function Results({ loading, results, resultFile }) {
  if (loading) {
    return (
      <div className="text-center my-5">
        <Spinner animation="border" role="status" variant="primary" />
        <p className="mt-3">Analyzing programs, please wait...</p>
      </div>
    );
  }

  if (!results) {
    return null;
  }

  const handleDownload = () => {
    if (resultFile && resultFile.data) {
      // Convert base64 to blob
      const byteCharacters = atob(resultFile.data);
      const byteArrays = [];
      for (let offset = 0; offset < byteCharacters.length; offset += 512) {
        const slice = byteCharacters.slice(offset, offset + 512);
        const byteNumbers = new Array(slice.length);
        for (let i = 0; i < slice.length; i++) {
          byteNumbers[i] = slice.charCodeAt(i);
        }
        const byteArray = new Uint8Array(byteNumbers);
        byteArrays.push(byteArray);
      }
      const blob = new Blob(byteArrays, { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
      saveAs(blob, resultFile.filename || 'program-evaluation-results.xlsx');
    }
  };

  const getBadgeVariant = (value) => {
    return value === 'H' ? 'success' : 'danger';
  };

  return (
    <div className="results-section">
      <h3 className="mb-4">Analysis Results</h3>
      <p>{results.length} programs analyzed and scored based on the evaluation criteria.</p>

      <div className="bg-light p-4 rounded mb-4">
        <h5>Score Legend</h5>
        <div className="d-flex flex-wrap gap-3">
          <div>
            <Badge bg="success" className="me-1">H</Badge> <strong>Cost:</strong> Higher than threshold
          </div>
          <div>
            <Badge bg="danger" className="me-1">L</Badge> <strong>Cost:</strong> Lower than threshold
          </div>
          <div>
            <Badge bg="success" className="me-1">H</Badge> <strong>Impact:</strong> High societal impact
          </div>
          <div>
            <Badge bg="success" className="me-1">H</Badge> <strong>Mandate:</strong> Required by higher government
          </div>
          <div>
            <Badge bg="success" className="me-1">H</Badge> <strong>Reliance:</strong> High reliance on government
          </div>
        </div>
      </div>

      <div className="table-responsive">
        <Table striped bordered hover>
          <thead>
            <tr>
              <th>Department</th>
              <th>Program</th>
              <th>Total Cost</th>
              <th>Cost</th>
              <th>Impact</th>
              <th>Mandate</th>
              <th>Reliance</th>
            </tr>
          </thead>
          <tbody>
            {results.map((item, index) => (
              <tr key={index}>
                <td>{item.department}</td>
                <td>{item.program}</td>
                <td>${item.totalCost.toLocaleString()}</td>
                <td>
                  <Badge bg={getBadgeVariant(item.cost)} className="d-flex justify-content-center align-items-center" style={{ height: '24px', width: '24px', borderRadius: '50%' }}>
                    {item.cost}
                  </Badge>
                </td>
                <td>
                  <Badge bg={getBadgeVariant(item.impact)} className="d-flex justify-content-center align-items-center" style={{ height: '24px', width: '24px', borderRadius: '50%' }}>
                    {item.impact}
                  </Badge>
                </td>
                <td>
                  <Badge bg={getBadgeVariant(item.mandate)} className="d-flex justify-content-center align-items-center" style={{ height: '24px', width: '24px', borderRadius: '50%' }}>
                    {item.mandate}
                  </Badge>
                </td>
                <td>
                  <Badge bg={getBadgeVariant(item.reliance)} className="d-flex justify-content-center align-items-center" style={{ height: '24px', width: '24px', borderRadius: '50%' }}>
                    {item.reliance}
                  </Badge>
                </td>
              </tr>
            ))}
          </tbody>
        </Table>
      </div>

      {resultFile && (
        <div className="text-center mt-4">
          <Button variant="success" onClick={handleDownload}>
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-download me-2" viewBox="0 0 16 16">
              <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
              <path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/>
            </svg>
            Download Excel Results
          </Button>
        </div>
      )}
    </div>
  );
}

export default Results;
EOF

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