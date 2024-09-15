import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'api_constants.dart';
import 'unauthorised_exception.dart';

class ApiClient {
  final Client _client;

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
    await Future.delayed(const Duration(milliseconds: 500));
    final response = await _client.get(
      getPath(path, params),
      headers: _buildHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic post(String path, {Map<dynamic, dynamic>? params}) async {
    try {
      final response = await _client.post(
        getPath(path, null),
        body: jsonEncode(params),
        headers: _buildHeaders(),
      );

      // Print raw response for debugging
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
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
    Request request = Request('DELETE', getPath(path, null));
    request.headers.addAll(_buildHeaders());
    request.body = jsonEncode(params);
    final response = await _client.send(request).then(
          (value) => Response.fromStream(value),
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

    return headers;
  }
}
