 class MoodSurveyData {
  double q1;
  double q2;
  double q3;
  double q4;
  double q5;
  double q6;

  MoodSurveyData({
    this.q1 = 2,
    this.q2 = 2,
    this.q3 = 2,
    this.q4 = 2,
    this.q5 = 2,
    this.q6 = 2,
  });

  Map<String, dynamic> toMap() => {
        'q1': q1,
        'q2': q2,
        'q3': q3,
        'q4': q4,
        'q5': q5,
        'q6': q6,
      };
}
