import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/error_messages.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await _client
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(ErrorMessages.networkError);
            },
          );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(ErrorMessages.serverError);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(ErrorMessages.networkError);
    }
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(ErrorMessages.networkError);
            },
          );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(ErrorMessages.serverError);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(ErrorMessages.networkError);
    }
  }
}
