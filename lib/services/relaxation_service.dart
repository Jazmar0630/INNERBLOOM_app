import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mental_app/config/api_config.dart';

class RelaxationService {
  static Future<String> generateRelaxation({
    required String mood,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/generateRelaxation');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mood': mood,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result']; // adjust to your backend response
    } else {
      throw Exception(
        'Failed to generate relaxation (${response.statusCode})',
      );
    }
  }
}
