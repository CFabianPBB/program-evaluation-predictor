const express = require('express');
const router = express.Router();
const XLSX = require('xlsx');
const fs = require('fs');
const path = require('path');
const { analyzePrograms } = require('../services/openaiService');

// Endpoint for uploading and analyzing Excel files
router.post('/analyze', async (req, res) => {
  try {
    // Check if file, website URL, and threshold are provided
    if (!req.files || !req.files.file) {
      return res.status(400).json({ error: 'No Excel file uploaded' });
    }

    const { websiteUrl, costThreshold } = req.body;
    
    if (!websiteUrl) {
      return res.status(400).json({ error: 'Website URL is required' });
    }

    if (!costThreshold || isNaN(costThreshold)) {
      return res.status(400).json({ error: 'Valid cost threshold is required' });
    }

    const excelFile = req.files.file;
    const threshold = parseFloat(costThreshold);

    // Check file type
    if (!excelFile.name.match(/\.(xlsx|xls)$/)) {
      return res.status(400).json({ error: 'Only Excel files are allowed' });
    }

    // Create a temporary file path
    const tempFilePath = path.join(__dirname, '..', 'temp', excelFile.name);
    
    // Ensure temp directory exists
    if (!fs.existsSync(path.join(__dirname, '..', 'temp'))) {
      fs.mkdirSync(path.join(__dirname, '..', 'temp'), { recursive: true });
    }
    
    // Move the uploaded file to the temp directory
    await excelFile.mv(tempFilePath);

    // Read the Excel file
    const workbook = XLSX.readFile(tempFilePath);
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    
    // Convert to JSON
    const programsData = XLSX.utils.sheet_to_json(worksheet);

    // Process the data
    const analysisResults = await analyzePrograms(programsData, websiteUrl, threshold);

    // Create a new workbook with the analysis results
    const newWorkbook = XLSX.utils.book_new();
    const newWorksheet = XLSX.utils.json_to_sheet(analysisResults);
    XLSX.utils.book_append_sheet(newWorkbook, newWorksheet, 'Sheet1');

    // Save the new workbook to a temporary file
    const resultFilePath = path.join(__dirname, '..', 'temp', 'analysis_result.xlsx');
    XLSX.writeFile(newWorkbook, resultFilePath);

    // Read the file to send as a response
    const fileBuffer = fs.readFileSync(resultFilePath);
    const base64File = fileBuffer.toString('base64');

    // Clean up temporary files
    fs.unlinkSync(tempFilePath);
    fs.unlinkSync(resultFilePath);

    // Send the results
    res.json({
      message: 'Analysis completed successfully',
      results: analysisResults,
      resultFile: base64File
    });
  } catch (error) {
    console.error('Error in /api/analyze:', error);
    res.status(500).json({ error: error.message || 'Server error during analysis' });
  }
});

module.exports = router;