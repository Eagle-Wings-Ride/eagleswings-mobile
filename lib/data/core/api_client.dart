import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as https;

import '../../presentation/screens/auth/login.dart';
import 'api_constants.dart';
import 'unauthorised_exception.dart';

class ApiClient {
  final https.Client _client;

  String? _bearerToken; // Store the bearer token
  String? get token => _bearerToken;

  ApiClient(this._client, [this._bearerToken]);

  // Method to update the token after login
  void setToken(String newToken) async {
    _bearerToken = newToken;
    print('New bearer token: $_bearerToken');
    print('New  token: $newToken');
  }

  dynamic get(String path, {Map<dynamic, dynamic>? params}) async {
    // await Future.delayed(const Duration(milliseconds: 500));
    var box = await Hive.openBox('authBox');
    final token = box.get('auth_token');

    try {
      final response = await _client
          .get(
            getPath(path, params),
            headers: _buildHeaders(token),
          )
          .timeout(const Duration(seconds: 15)); // 10 seconds timeout
      if (response.statusCode == 404) {
        return json.decode(response.body);
      }

      if (response.statusCode == 200) {
        // Log and return the decoded body
        print('Decoding response body');
        print(json.decode(response.body));
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        // Handle unauthorized - clear auth and redirect to login
        await box.delete('auth_token');
        await box.clear();
        print('Unauthorized access, redirecting to login');
        Get.offAll(const Login());
        throw Exception('Unauthorized access');
      } else {
        // Try to extract error message from response
        try {
          final body = jsonDecode(response.body);
          final message = body['message'];
          if (message != null &&
              message.toString().contains('Invalid or expired token')) {
            await box.delete('auth_token');
            await box.clear();
            Get.offAll(const Login());
            throw Exception('Session expired');
          }
        } catch (_) {
          // Could not parse body, continue with generic error
        }
        print('Error response: ${response.reasonPhrase}');
        throw Exception(
            'Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception caught: $e');
      if (e is TimeoutException) {
        throw Exception("Request timed out. Please try again.");
      } else {
        rethrow;
      }
    }
  }

  dynamic post(String path, {Map<dynamic, dynamic>? params}) async {
    var box = await Hive.openBox('authBox');
    final token = box.get('auth_token');
    try {
      print(path);
      final response = await _client
          .post(
            getPath(path, null),
            body: jsonEncode(params),
            headers: _buildHeaders(token),
          )
          .timeout(const Duration(seconds: 15));

      print('response.statusCode');

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('response.body here');
        debugPrint(response.body);
        return json.decode(response.body); // Success case
      } else {
        // Decode the error message from the response body
        final errorResponse = json.decode(response.body);
        debugPrint('errorResponse');
        // print(json.decode(response.body));
        debugPrint(response.body);
        final errorMessage =
            errorResponse['message'] ?? 'Unknown error occurred';
        debugPrint('errorMessage');
        debugPrint(errorMessage);

        // Throw an exception with the error message from backend
        throw errorMessage;
      }
    } on UnauthorisedException {
      throw UnauthorisedException();
    } catch (e) {
      // Handle other exceptions
      // print('Exception caught: $e');
      if (e is TimeoutException) {
        throw Exception("Request timed out. Please try again.");
      } else {
        rethrow;
      }
    }
  }

  dynamic deleteWithBody(String path, {Map<dynamic, dynamic>? params}) async {
    var box = await Hive.openBox('authBox');
    final token = box.get('auth_token');
    https.Request request = https.Request('DELETE', getPath(path, null));
    request.headers.addAll(_buildHeaders(token));
    request.body = jsonEncode(params);
    final response = await _client.send(request).then(
          (value) => https.Response.fromStream(value),
        );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  // PATCH request for updates
  dynamic patch(String path, {Map<dynamic, dynamic>? params}) async {
    var box = await Hive.openBox('authBox');
    final token = box.get('auth_token');
    try {
      print('PATCH request to: $path');
      final response = await _client
          .patch(
            getPath(path, null),
            body: jsonEncode(params),
            headers: _buildHeaders(token),
          )
          .timeout(const Duration(seconds: 15));

      print('PATCH response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('PATCH response body: ${response.body}');
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        await box.delete('auth_token');
        await box.clear();
        print('Unauthorized access, redirecting to login');
        Get.offAll(const Login());
        throw Exception('Unauthorized access');
      } else {
        final errorResponse = json.decode(response.body);
        final errorMessage =
            errorResponse['message'] ?? 'Unknown error occurred';
        debugPrint('PATCH error: $errorMessage');
        throw errorMessage;
      }
    } on UnauthorisedException {
      throw UnauthorisedException();
    } catch (e) {
      if (e is TimeoutException) {
        throw Exception("Request timed out. Please try again.");
      } else {
        rethrow;
      }
    }
  }

  // DELETE request
  dynamic delete(String path) async {
    var box = await Hive.openBox('authBox');
    final token = box.get('auth_token');
    try {
      print('DELETE request to: $path');
      final response = await _client
          .delete(
            getPath(path, null),
            headers: _buildHeaders(token),
          )
          .timeout(const Duration(seconds: 15));

      print('DELETE response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        }
        return {'message': 'Deleted successfully'};
      } else if (response.statusCode == 401) {
        await box.delete('auth_token');
        await box.clear();
        print('Unauthorized access, redirecting to login');
        Get.offAll(const Login());
        throw Exception('Unauthorized access');
      } else {
        final errorResponse = json.decode(response.body);
        final errorMessage =
            errorResponse['message'] ?? 'Unknown error occurred';
        debugPrint('DELETE error: $errorMessage');
        throw errorMessage;
      }
    } on UnauthorisedException {
      throw UnauthorisedException();
    } catch (e) {
      if (e is TimeoutException) {
        throw Exception("Request timed out. Please try again.");
      } else {
        rethrow;
      }
    }
  }

  // PUT request
  dynamic put(String path, {Map<dynamic, dynamic>? params}) async {
    var box = await Hive.openBox('authBox');
    final token = box.get('auth_token');
    try {
      print('PUT request to: $path');
      final response = await _client
          .put(
            getPath(path, null),
            body: jsonEncode(params),
            headers: _buildHeaders(token),
          )
          .timeout(const Duration(seconds: 15));

      print('PUT response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('PUT response body: ${response.body}');
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        await box.delete('auth_token');
        await box.clear();
        print('Unauthorized access, redirecting to login');
        Get.offAll(const Login());
        throw Exception('Unauthorized access');
      } else {
        final errorResponse = json.decode(response.body);
        final errorMessage =
            errorResponse['message'] ?? 'Unknown error occurred';
        debugPrint('PUT error: $errorMessage');
        throw errorMessage;
      }
    } on UnauthorisedException {
      throw UnauthorisedException();
    } catch (e) {
      if (e is TimeoutException) {
        throw Exception("Request timed out. Please try again.");
      } else {
        rethrow;
      }
    }
  }

  Future<dynamic> postMultipart(
    String path, {
    required Map<String, String> fields,
    File? file,
    String fileField = 'image',
  }) async {
    return _sendMultipart(
      'POST',
      path,
      fields: fields,
      file: file,
      fileField: fileField,
    );
  }

  Future<dynamic> patchMultipart(
    String path, {
    required Map<String, String> fields,
    File? file,
    String fileField = 'image',
  }) async {
    return _sendMultipart(
      'PATCH',
      path,
      fields: fields,
      file: file,
      fileField: fileField,
    );
  }

  Future<dynamic> _sendMultipart(
    String method,
    String path, {
    required Map<String, String> fields,
    File? file,
    String fileField = 'image',
  }) async {
    var box = await Hive.openBox('authBox');
    final token = box.get('auth_token');

    try {
      final request = https.MultipartRequest(method, getPath(path, null))
        ..headers.addAll(_buildMultipartHeaders(token))
        ..fields.addAll(fields);

      if (file != null && await file.exists()) {
        request.files.add(
          await https.MultipartFile.fromPath(fileField, file.path),
        );
      }

      final streamedResponse =
          await _client.send(request).timeout(const Duration(seconds: 15));
      final response = await https.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.trim().isEmpty) {
          return <String, dynamic>{};
        }
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        await box.delete('auth_token');
        await box.clear();
        Get.offAll(const Login());
        throw Exception('Unauthorized access');
      } else {
        String errorMessage = 'Unknown error occurred';
        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? errorMessage;
        } catch (_) {
          errorMessage =
              'Error: ${response.statusCode} - ${response.reasonPhrase}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is TimeoutException) {
        throw Exception("Request timed out. Please try again.");
      }
      rethrow;
    }
  }

  Uri getPath(String path, Map<dynamic, dynamic>? params) {
    final baseUri = Uri.parse('${ApiConstants.baseUrl}$path');
    if (params == null || params.isEmpty) {
      return baseUri;
    }

    final mergedQueryParameters = <String, String>{
      ...baseUri.queryParameters,
      ...params.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      ),
    };

    return baseUri.replace(queryParameters: mergedQueryParameters);
  }

  Map<String, String> _buildHeaders(token) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (token != null && token.toString().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Map<String, String> _buildMultipartHeaders(token) {
    final headers = <String, String>{};
    if (token != null && token.toString().isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}
