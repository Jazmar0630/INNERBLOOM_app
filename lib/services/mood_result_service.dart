 import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mental_app/config/api_config.dart';

class MoodResultService {
  static Future<String> getSuggestion({required String mood}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/generateRelaxation');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mood': mood}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ✅ Make sure backend returns { "result": "..." }
      return (data['relaxation'] ?? '').toString();
    } else {
      throw Exception('Failed (${response.statusCode})');
    }
  }
}
