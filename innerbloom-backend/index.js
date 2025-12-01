import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { GoogleGenerativeAI } from "@google/generative-ai";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// Initialize Gemini
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

app.get("/", (req, res) => {
  res.send("InnerBloom Backend is running.");
})

// API Endpoint for InnerBloom
app.post("/generateRelaxation", async (req, res) => {
  try {
    const { mood } = req.body;

    const model = genAI.getGenerativeModel({ model: "gemini-2.5-pro" });

    const prompt = `
    The user is feeling: ${mood}.
    You are a mental wellbeing assistant.
    Generate a short, calming relaxation exercise (60–120 words).
    Keep it simple, soothing, calming, and safe for teenagers.
    Avoid medical advice.
    `;

    const result = await model.generateContent(prompt);
    const reply = result.response.text();

    res.json({ relaxation: reply });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error generating relaxation exercise." });
  }
});

app.listen(3000, () => {
  console.log("Backend running at http://localhost:3000");
});
