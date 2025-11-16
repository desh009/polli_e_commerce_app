import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:polli_e_commerce_app/core/network/api_response.dart';

class NetworkClient {
  final Logger _logger = Logger();
  final Map<String, String> Function() commonHeaders;
  final VoidCallback onUnAuthorize;
  final String _defaultMessage = 'Something went wrong';

  NetworkClient({required this.onUnAuthorize, required this.commonHeaders});

  Future<NetworkResponse> getRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders());
      final Response response = await get(uri, headers: commonHeaders());
      _logResponse(response);
      
      return _handleResponse(response);
      
    } on Exception catch (e) {
      _logger.e('GET Request Exception: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> postRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders(), body: body);
      final Response response = await post(
        uri,
        headers: commonHeaders(),
        body: jsonEncode(body),
      );
      _logResponse(response);
      
      return _handleResponse(response);
      
    } on Exception catch (e) {
      _logger.e('POST Request Exception: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> putRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders(), body: body);
      final Response response = await put(
        uri,
        headers: commonHeaders(),
        body: jsonEncode(body),
      );
      _logResponse(response);
      
      return _handleResponse(response);
      
    } on Exception catch (e) {
      _logger.e('PUT Request Exception: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> patchRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders(), body: body);
      final Response response = await patch(
        uri,
        headers: commonHeaders(),
        body: jsonEncode(body),
      );
      _logResponse(response);
      
      return _handleResponse(response);
      
    } on Exception catch (e) {
      _logger.e('PATCH Request Exception: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> deleteRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders());
      final Response response = await delete(
        uri,
        headers: commonHeaders(),
      );
      _logResponse(response);
      
      return _handleResponse(response);
      
    } on Exception catch (e) {
      _logger.e('DELETE Request Exception: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  // ✅ FIXED: Common response handler method
  NetworkResponse _handleResponse(Response response) {
    try {
      print('📊 Handling response with status: ${response.statusCode}');
      print('📊 Response body type: ${response.body.runtimeType}');
      print('📊 Response body length: ${response.body.length}');

      // ✅ FIXED: Handle response data properly
      dynamic responseData;
      
      if (response.body.isEmpty) {
        responseData = null;
        print('⚠️ Response body is empty');
      } else {
        // Try to decode JSON
        try {
          responseData = jsonDecode(response.body);
          print('✅ Successfully decoded JSON response');
          print('📊 Decoded response type: ${responseData.runtimeType}');
        } catch (e) {
          print('⚠️ JSON decode failed, using raw response body as String');
          responseData = response.body;
        }
      }

      // Handle different status codes
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: responseData,
        );
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Un-Authorized',
        );
      } else {
        String errorMessage = _extractErrorMessage(responseData);
        
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      print('❌ Error handling response: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Error processing response: $e',
      );
    }
  }

  // ✅ FIXED: Error message extraction
  String _extractErrorMessage(dynamic responseData) {
    try {
      if (responseData == null) {
        return _defaultMessage;
      }
      
      if (responseData is Map) {
        return responseData['msg']?.toString() ?? 
               responseData['message']?.toString() ?? 
               responseData['error']?.toString() ?? 
               responseData['error_message']?.toString() ?? 
               _defaultMessage;
      } else if (responseData is String) {
        // Try to parse string as JSON first
        try {
          final Map<String, dynamic> parsed = jsonDecode(responseData);
          return _extractErrorMessage(parsed);
        } catch (e) {
          // If parsing fails, use the string directly
          return responseData.isNotEmpty ? responseData : _defaultMessage;
        }
      } else {
        return responseData.toString();
      }
    } catch (e) {
      print('❌ Error extracting error message: $e');
      return _defaultMessage;
    }
  }

  void _logRequest(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) {
    final String message =
        '''
┌────────────────────────────────────────────────────────────────────────────
│ #0   NetworkClient._logRequest
├────────────────────────────────────────────────────────────────────────────
│ 💡 URL: $url
│ 💡 HEADERS: $headers
│ 💡 BODY: $body
└────────────────────────────────────────────────────────────────────────────
''';
    _logger.i(message);
  }

  void _logResponse(Response response) {
    final String message =
        '''
┌────────────────────────────────────────────────────────────────────────────
│ #0   NetworkClient._logResponse
├────────────────────────────────────────────────────────────────────────────
│ 💡 URL: ${response.request?.url}
│ 💡 STATUS: ${response.statusCode}
│ 💡 HEADERS: ${response.headers}
│ 💡 BODY: ${response.body}
└────────────────────────────────────────────────────────────────────────────
''';
    _logger.i(message);
  }
}