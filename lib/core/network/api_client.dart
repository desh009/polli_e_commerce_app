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
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Un-Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: responseBody['msg'] ?? _defaultMessage,
        );
      }
    } on Exception catch (e) {
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Un-Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: responseBody['msg'] ?? _defaultMessage,
        );
      }
    } on Exception catch (e) {
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Un-Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: responseBody['msg'] ?? _defaultMessage,
        );
      }
    } on Exception catch (e) {
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Un-Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: responseBody['msg'] ?? _defaultMessage,
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> deleteRequest(
    String url) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, headers: commonHeaders());
      final Response response = await delete(
        uri,
        headers: commonHeaders(),

      );
      _logResponse(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: responseBody,
        );
      } else if (response.statusCode == 401) {
        onUnAuthorize();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Un-Authorize',
        );
      } else {
        final responseBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: responseBody['msg'] ?? _defaultMessage,
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  void _logRequest(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) {
    final String message =
        '''
    URL-> $url
    HEADERS-> $headers
    BODY-> $body
    ''';
    _logger.i(message);
  }

  void _logResponse(Response response) {
    final String message =
        '''
    URL-> ${response.request?.url}
    STATUS-CODE-> ${response.statusCode}
    HEADERS-> ${response.headers}
    BODY-> ${response.body}
    ''';
    _logger.i(message);
  }
}



// final responseBody = jsonDecode(response.body);

// class response {
//   static String? get body => null;
// }
// final product = ProductModel.fromJson(responseBody);

// mixin ProductModel {
//   static fromJson(responseBody) {}
// }