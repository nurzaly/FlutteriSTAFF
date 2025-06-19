import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:istaff/data/constants.dart' as constants;

class ApiClient {
  final String _baseUrl = constants.apiBaseUrl;

  Future<Map<String, String>> _buildHeaders([Map<String, String>? customHeaders]) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(constants.Kprefs.authTokenKey) ?? '';

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      ...?customHeaders,
    };
  }

  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final fullHeaders = await _buildHeaders(headers);

    _logRequest('GET', uri, headers: fullHeaders);
    final response = await http.get(uri, headers: fullHeaders);
    return _processResponse(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final fullHeaders = await _buildHeaders(headers);

    _logRequest('POST', uri, headers: fullHeaders, body: body);
    final response = await http.post(
      uri,
      headers: fullHeaders,
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final fullHeaders = await _buildHeaders(headers);

    _logRequest('PUT', uri, headers: fullHeaders, body: body);
    final response = await http.put(
      uri,
      headers: fullHeaders,
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  Future<dynamic> delete(String path, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final fullHeaders = await _buildHeaders(headers);

    _logRequest('DELETE', uri, headers: fullHeaders);
    final response = await http.delete(uri, headers: fullHeaders);
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    _logResponse(response);

    final jsonBody = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonBody;
    } else if (response.statusCode == 401) {
      // Optional: trigger token refresh and retry once
      throw Exception('Unauthorized. Token may have expired.');
    } else {
      throw Exception(jsonBody['message'] ?? 'Something went wrong');
    }
  }

  void _logRequest(String method, Uri uri, {Map<String, String>? headers, Map<String, dynamic>? body}) {
    print('📤 $method Request to: $uri');
    if (headers != null) print('🔐 Headers: $headers');
    if (body != null) print('📦 Body: $body');
  }

  void _logResponse(http.Response response) {
    print('📥 Response [${response.statusCode}]: ${response.body}');
  }
}
