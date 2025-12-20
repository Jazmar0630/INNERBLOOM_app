 class MoodSurveyResponse {
  // Page 1
  final int stress1; // "How stressed do you feel?"
  final int sleep1;  // "How well did you sleep?" (positive wording)
  final int focus1;  // "How focused are you today?" (positive wording)

  // Page 2 (new)
  final int stress2; // overwhelmed
  final int sleep2;  // trouble sleeping
  final int focus2;  // distracted easily

  MoodSurveyResponse({
    required this.stress1,
    required this.sleep1,
    required this.focus1,
    required this.stress2,
    required this.sleep2,
    required this.focus2,
  });

  Map<String, dynamic> toJson() => {
    "stress1": stress1,
    "sleep1": sleep1,
    "focus1": focus1,
    "stress2": stress2,
    "sleep2": sleep2,
    "focus2": focus2,
  };
}
