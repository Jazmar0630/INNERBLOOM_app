 // index.js — InnerBloom backend (Node + Express + Gemini)
// Make sure package.json has: "type": "module"

import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { GoogleGenerativeAI } from "@google/generative-ai";

dotenv.config();

// Check that the API key is loaded (won't print the key itself)
if (!process.env.GEMINI_API_KEY) {
  console.error("❌ GEMINI_API_KEY is missing from .env");
} else {
  console.log("✅ GEMINI_API_KEY loaded");
}

const app = express();
app.use(cors());
app.use(express.json());

// --------------------
// Gemini initialisation
// --------------------
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
// This model name should match what your key supports
const GEMINI_MODEL_ID = "gemini-flash-latest";

// In-memory storage for survey results (later you can replace with a DB)
const surveyData = new Map();

// -------------------------------------------------
// 1) GET /  → health check (Thunder: GET http://localhost:3000/)
// -------------------------------------------------
app.get("/", (req, res) => {
  res.send("InnerBloom Backend is running.");
});

// -------------------------------------------------
// 2) POST /generateRelaxation
//    Thunder: POST http://localhost:3000/generateRelaxation
//    Body JSON: { "mood": "I feel stressed and overwhelmed" }
// -------------------------------------------------
app.post("/generateRelaxation", async (req, res) => {
  try {
    const { mood } = req.body;

    if (!mood) {
      return res.status(400).json({ error: "mood is required in the body." });
    }

    const model = genAI.getGenerativeModel({ model: GEMINI_MODEL_ID });

    const prompt = `
      The user says they are feeling: "${mood}".
      You are a gentle, supportive mental wellbeing assistant.
      Generate a short, calming relaxation exercise (60–120 words).
      Keep it simple, soothing, and suitable for teenagers.
      Use safe techniques like breathing, grounding, visualization,
      or gentle movement. Do NOT give medical or diagnostic advice.
    `;

    const result = await model.generateContent(prompt);
    const reply = result.response.text();

    return res.json({ relaxation: reply });
  } catch (error) {
    console.error("❌ Error in /generateRelaxation:", error?.message || error);
    return res
      .status(500)
      .json({ error: "Error generating relaxation exercise." });
  }
});

// -------------------------------------------------
// 3) POST /api/survey
//    Thunder: POST http://localhost:3000/api/survey
//    Body JSON:
//    {
//       "userId": "ammar",
//       "stress": 8,
//       "mood": 3,
//       "sleep": 4
//    }
// -------------------------------------------------
app.post("/api/survey", async (req, res) => {
  try {
    const { userId, stress, mood, sleep } = req.body;

    if (!userId) {
      return res.status(400).json({ error: "userId is required." });
    }

    const s = Number(stress);
    const m = Number(mood);
    const sl = Number(sleep);

    let outcome = "";
    const recommendations = [];

    if (!Number.isNaN(s) && s >= 7) {
      outcome = "High stress";
      recommendations.push(
        "Deep breathing exercise (5–10 minutes)",
        "Guided body scan meditation",
        "Soft piano or ambient relaxation sounds"
      );
    } else if (!Number.isNaN(m) && m <= 3) {
      outcome = "Low mood";
      recommendations.push(
        "Positive affirmation audio",
        "Short mindful walk outside",
        "Gratitude journaling for 3 good things"
      );
    } else if (!Number.isNaN(sl) && sl <= 4) {
      outcome = "Poor sleep quality";
      recommendations.push(
        "Avoid screens 30 minutes before bed",
        "Rain / nature sounds for sleep",
        "4-7-8 breathing technique before sleeping"
      );
    } else {
      outcome = "Relatively balanced, but can improve";
      recommendations.push(
        "5-minute breathing break during the day",
        "Light stretching with calm music",
        "Short mindfulness check-in in the evening"
      );
    }

    // ---------- Gemini explanation based on scores ----------
    let geminiExplanation = "";
    try {
      const model = genAI.getGenerativeModel({ model: GEMINI_MODEL_ID });

      const explainPrompt = `
        You are a calm and supportive mental wellbeing assistant.
        A user completed a wellbeing survey with these scores (0–10 scale):
        - Stress: ${s}
        - Mood: ${m}
        - Sleep: ${sl}

        Our simple rule-based system gave them this outcome: "${outcome}".

        Write a short explanation (80–150 words) that:
        - Acknowledges how they might be feeling.
        - Briefly explains why this outcome makes sense.
        - Encourages small, realistic self-care steps.
        - Is safe and suitable for teenagers.
        - Does NOT give any medical, diagnostic, or medication advice.
      `;

      const gemResult = await model.generateContent(explainPrompt);
      geminiExplanation = gemResult.response.text();
    } catch (gErr) {
      console.error("⚠ Gemini explanation error:", gErr?.message || gErr);
      geminiExplanation = "";
    }

    const result = {
      userId,
      outcome,
      recommendations,
      geminiExplanation,
      rawScores: { stress: s, mood: m, sleep: sl },
      timestamp: new Date().toISOString(),
    };

    // Save in memory
    surveyData.set(userId, result);

    return res.json({
      status: "success",
      message: "Survey processed successfully",
      data: result,
    });
  } catch (error) {
    console.error("❌ Error in /api/survey:", error?.message || error);
    return res.status(500).json({ error: "Error processing survey." });
  }
});

// -------------------------------------------------
// 4) GET /api/recommendation/:userId
//    Thunder: GET http://localhost:3000/api/recommendation/ammar
// -------------------------------------------------
app.get("/api/recommendation/:userId", (req, res) => {
  const { userId } = req.params;

  if (!surveyData.has(userId)) {
    return res.status(404).json({
      error: "No survey data found for this user yet.",
    });
  }

  return res.json({
    status: "success",
    data: surveyData.get(userId),
  });
});

// --------------------
// Start server
// --------------------
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Backend running at http://localhost:${PORT}`);
});
