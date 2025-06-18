import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:istaff/data/constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final String _baseUrl = constants.apiBaseUrl;

  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse('$_baseUrl$path'), headers: headers);
    return _processResponse(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      // headers: headers ?? {'Content-Type': 'application/json'},
      headers: headers ?? {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString(constants.Kprefs.authTokenKey)}'
        },
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    final jsonBody = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonBody;
    } else {
      throw Exception(jsonBody['message'] ?? 'Something went wrong');
    }
  }
}
