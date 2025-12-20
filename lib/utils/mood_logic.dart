 import '../model/mood_survey_response.dart';

int reverse4(int v) => 4 - v;

/// Returns score 0..8 for each category (higher = worse)
Map<String, int> computeScores(MoodSurveyResponse r) {
  // sleep1 and focus1 are positive questions -> reverse them
  final stressScore = r.stress1 + r.stress2;                 // 0..8
  final sleepScore  = reverse4(r.sleep1) + r.sleep2;         // 0..8
  final focusScore  = reverse4(r.focus1) + r.focus2;         // 0..8

  return {
    "stress": stressScore,
    "sleep": sleepScore,
    "focus": focusScore,
  };
}

String levelFromScore(int score) {
  if (score <= 2) return "low";      // good
  if (score <= 5) return "mid";      // medium
  return "high";                     // danger
}

String labelForCategory(String category, String level) {
  switch (category) {
    case "stress":
      if (level == "low") return "Low Stress • Excellent";
      if (level == "mid") return "Mid Stress • Moderate";
      return "High Stress • Danger";
    case "sleep":
      // sleep score high = worse sleep, so labels invert
      if (level == "low") return "High Sleep • Good";
      if (level == "mid") return "Mid Sleep • Medium";
      return "Low Sleep • Danger";
    case "focus":
      if (level == "low") return "High Focus • Excellent";
      if (level == "mid") return "Mid Focus • Medium";
      return "Low Focus • Danger";
    default:
      return "";
  }
}

/// Soft triggers (NOT diagnosis)
List<String> computeTriggers({
  required String stressLevel,
  required String sleepLevel,
  required String focusLevel,
}) {
  final triggers = <String>[];

  // Anxiety tendency: high stress + (sleep not good OR focus not good)
  if (stressLevel == "high" && (sleepLevel != "low" || focusLevel != "low")) {
    triggers.add("Anxiety tendency (based on stress + sleep/focus pattern)");
  }

  // Low mood tendency: poor sleep + low focus (stress can be any)
  if (sleepLevel == "high" && focusLevel == "high") {
    triggers.add("Low mood tendency (based on low sleep + low focus pattern)");
  }

  // Burnout risk: high stress + low sleep + low focus
  if (stressLevel == "high" && sleepLevel == "high" && focusLevel == "high") {
    triggers.add("Burnout risk (high stress + low sleep + low focus)");
  }

  return triggers;
}
