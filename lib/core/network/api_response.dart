// api_response.dart
import 'dart:convert'; // ✅ ADD THIS IMPORT

class NetworkResponse {
  final int statusCode;
  final bool isSuccess;
  final dynamic responseData;
  final String? errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage,
  });

  // ✅ Helper method to safely get response as Map
  Map<String, dynamic>? get responseMap {
    if (responseData == null) return null;
    
    if (responseData is Map<String, dynamic>) {
      return responseData;
    } else if (responseData is Map) {
      return responseData.cast<String, dynamic>();
    } else if (responseData is String) {
      try {
        return jsonDecode(responseData) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // ✅ Helper method to safely get response as String
  String? get responseString {
    if (responseData == null) return null;
    
    if (responseData is String) {
      return responseData;
    } else if (responseData is Map) {
      return jsonEncode(responseData);
    }
    return responseData.toString();
  }

  // ✅ Helper to check if response data is Map
  bool get isResponseMap => responseMap != null;

  // ✅ Helper to check if response data is String
  bool get isResponseString => responseData is String;

  @override
  String toString() {
    return 'NetworkResponse{statusCode: $statusCode, isSuccess: $isSuccess, responseData: $responseData, errorMessage: $errorMessage}';
  }
}