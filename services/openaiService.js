const { OpenAI } = require('openai');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config();

// Initialize OpenAI client
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

/**
 * Analyze government programs using OpenAI
 * @param {Array} programs - Array of program data from Excel
 * @param {string} websiteUrl - Government website URL for context
 * @param {number} costThreshold - Threshold to determine high/low cost
 * @returns {Array} - Analyzed programs with evaluation scores
 */
async function analyzePrograms(programs, websiteUrl, costThreshold) {
  try {
    // Create a copy of the programs data to avoid modifying the original
    const analyzedPrograms = [...programs];
    
    // Process each program
    for (let i = 0; i < analyzedPrograms.length; i++) {
      const program = analyzedPrograms[i];
      
      // Cost evaluation - based on comparison with threshold
      const programCost = parseFloat(program[' Total Cost ']);
      program.Cost = programCost > costThreshold ? 'H' : 'L';
      
      // Prepare context for OpenAI analysis
      const departmentName = program.Department;
      const programName = program.Program;
      const programDescription = program.Description;
      
      // Create prompt for OpenAI
      const prompt = `
        I need to evaluate a government program based on three criteria: Impact, Mandate, and Reliance.
        
        Program Details:
        - Department: ${departmentName}
        - Program Name: ${programName}
        - Description: ${programDescription}
        - Government Website: ${websiteUrl}
        
        For each of the following criteria, respond with ONLY a single letter - "H" for High or "L" for Low:
        
        1. Impact: Does this program have a very high impact on societal goals like making the community safer, improving the economy, improving transportation, safe water, etc.? (H/L)
        
        2. Mandate: Is this program likely required of the local government by either the Federal Government or State Government? (H/L)
        
        3. Reliance: Could this program be provided readily by or together with another partner in the public or non-profit or private sector? If yes, respond "L" for low reliance on government. If no, respond "H" for high reliance on government.
        
        Format your response as a JSON object with three keys: "Impact", "Mandate", and "Reliance", with values of only "H" or "L" for each.
      `;
      
      // Call OpenAI API
      const response = await openai.chat.completions.create({
        model: "gpt-3.5-turbo", // You can use "gpt-4" for better results if available
        messages: [
          {
            role: "system",
            content: "You are an expert in government program evaluation. Provide concise H/L evaluations based on the criteria."
          },
          {
            role: "user",
            content: prompt
          }
        ],
        temperature: 0.3, // Lower temperature for more consistent results
        max_tokens: 200
      });
      
      // Extract and parse the response
      const responseText = response.choices[0].message.content.trim();
      let evaluationResults;
      
      try {
        // Try to parse JSON response
        evaluationResults = JSON.parse(responseText);
      } catch (error) {
        // If JSON parsing fails, extract H/L values using regex
        const impactMatch = responseText.match(/Impact[^H|L]*(H|L)/i);
        const mandateMatch = responseText.match(/Mandate[^H|L]*(H|L)/i);
        const relianceMatch = responseText.match(/Reliance[^H|L]*(H|L)/i);
        
        evaluationResults = {
          Impact: impactMatch ? impactMatch[1].toUpperCase() : 'L',
          Mandate: mandateMatch ? mandateMatch[1].toUpperCase() : 'L',
          Reliance: relianceMatch ? relianceMatch[1].toUpperCase() : 'L'
        };
      }
      
      // Add evaluation results to the program data
      program.Impact = evaluationResults.Impact || 'L';
      program.Mandate = evaluationResults.Mandate || 'L';
      program.Reliance = evaluationResults.Reliance || 'L';
      
      // Log progress (for debugging)
      console.log(`Processed program ${i + 1}/${analyzedPrograms.length}: ${programName}`);
    }
    
    return analyzedPrograms;
  } catch (error) {
    console.error('Error in analyzePrograms:', error);
    throw new Error('Failed to analyze programs with OpenAI');
  }
}

module.exports = {
  analyzePrograms
};