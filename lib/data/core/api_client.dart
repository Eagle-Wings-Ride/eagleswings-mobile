import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:eaglerides/functions/function.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as https;

import '../../presentation/screens/auth/login.dart';
import 'api_constants.dart';
import 'unauthorised_exception.dart';

class ApiClient {
  final https.Client _client;

  final String? _bearerToken; // Store the bearer token

  ApiClient(this._client, [this._bearerToken]);

  // Helper function to get headers including the token if available
  // Map<String, String> _getHeaders() {
  //   final headers = {
  //     'Content-Type': 'application/json',
  //   };
  //   if (_bearerToken != null) {
  //     headers['Authorization'] = 'Bearer $_bearerToken';
  //   }
  //   return headers;
  // }

  dynamic get(String path, {Map<dynamic, dynamic>? params}) async {
    // await Future.delayed(const Duration(milliseconds: 500));
    final box = await Hive.openBox('authBox');

    try {
      final response = await _client.get(
        getPath(path, params),
        headers: _buildHeaders(),
      ); // 10 seconds timeout

      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');
      // print('Is 401: ${response.statusCode == 401}');

      // Check if the response body is empty or not
      if (response.body.isEmpty) {
        print('Empty response body');
        throw Exception('Empty response body');
      }

      if (response.statusCode == 200) {
        // Log and return the decoded body
        print('Decoding response body');
        print(json.decode(response.body));
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        await box.delete('auth_token');
        await box.clear();
        // Log the response before redirecting
        print('Unauthorized access, redirecting to login');
        Get.offAll(const Login());
        throw 'Unauthorized';
      } else {
        print('Error response: ${response.reasonPhrase}');
        throw Exception(
            'Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception caught: $e');
      rethrow;
    }
  }

  dynamic post(String path, {Map<dynamic, dynamic>? params}) async {
    try {
      print(path);
      final response = await _client.post(
        getPath(path, null),
        body: jsonEncode(params),
        headers: _buildHeaders(),
      );

      // final errorResponse = json.decode(response.body);
      // debugPrint('errorResponse');
      print('response.statusCode');
      print(json.decode(response.body)['message']);
      print('here');
      print(response.reasonPhrase);

      // Print raw response for debugging
      print("Response Body: ${response.body}");
      // print("Response Body: ${response.statusCode}");

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

      rethrow;
    }
  }

  dynamic deleteWithBody(String path, {Map<dynamic, dynamic>? params}) async {
    https.Request request = https.Request('DELETE', getPath(path, null));
    request.headers.addAll(_buildHeaders());
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

  Uri getPath(String path, Map<dynamic, dynamic>? params) {
    var paramsString = '';
    if (params?.isNotEmpty ?? false) {
      params?.forEach((key, value) {
        paramsString += '&$key=$value';
      });
    }

    return Uri.parse('${ApiConstants.baseUrl}$path$paramsString');
  }

  Map<String, String> _buildHeaders() {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (_bearerToken != null) {
      headers['Authorization'] = 'Bearer $_bearerToken';
    }

    print('_bearerToken');
    print(_bearerToken);

    return headers;
  }
}
