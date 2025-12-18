 class MoodSurveyData {
  double q1, q2, q3;
  MoodSurveyData({this.q1 = 2, this.q2 = 2, this.q3 = 2});

  Map<String, dynamic> toMap() => {'q1': q1, 'q2': q2, 'q3': q3};
}
