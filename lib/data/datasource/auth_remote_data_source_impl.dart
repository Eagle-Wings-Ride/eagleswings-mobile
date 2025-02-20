import 'dart:convert';

import 'package:eaglerides/data/models/register_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

import '../../injection_container.dart';
import '../../presentation/screens/auth/login.dart';
import '../core/api_client.dart';
import '../models/child_model.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class EagleRidesAuthDataSourceImpl extends EagleRidesAuthDataSource {
  var verId = "".obs;
  final ApiClient _client;

  EagleRidesAuthDataSourceImpl(this._client);

  @override
  Future<String> loginUser(String email, String password) async {
    const uri = '/users/login';
    try {
      final response = await _client.post(
        uri,
        params: {'email': email, 'password': password},
        // headers: {'Content-Type': 'application/json'},  // Ensure content-type is correct
      );
      // Convert response to string if it's not already
      debugPrint("Raw response: $response");

      if (response['token'] != null) {
        var box = await Hive.openBox('authBox');
        await box.put('auth_token', response['token']);
        debugPrint("Token saved: ${response['token']}");

        // Update the token in ApiClient instead of re-registering
        final apiClient = sl<ApiClient>();
        print('Current Token after login: ${apiClient.token}');
        apiClient.setToken(
            response['token']); // Update the token in the existing instance

        // await init();
        return response['token'];
      } else {
        throw Exception('Failed to login: No token found');
      }
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
      // throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<String> register(Map<String, dynamic> requestBody) async {
    const uri = '/users/register';
    try {
      final response = await _client.post(uri, params: requestBody);

      debugPrint('Response Body: $response');
      // Assume the response is a map, not a string
      if (response is Map<String, dynamic>) {
        // print('error here');
        debugPrint(response['message']);
        return response['message'];
      } else {
        return 'Unexpected response format';
      }
    } catch (e) {
      debugPrint('Exception: $e');
      rethrow;
    }
  }

  @override
  Future<String> bookRide(Map<String, dynamic> requestBody, childId) async {
    final uri = '/book/$childId';
    try {
      final response = await _client.post(uri, params: requestBody);

      debugPrint('Response Body: $response');
      // Assume the response is a map, not a string
      if (response is Map<String, dynamic>) {
        // print('error here');
        debugPrint(response['message']);
        return response['message'];
      } else {
        return 'Unexpected response format';
      }
    } catch (e) {
      debugPrint('Exception: $e');
      rethrow;
    }
  }

  @override
  Future<String> addChild(Map<String, dynamic> requestBody) async {
    const uri = '/users/child';

    try {
      final response = await _client.post(uri, params: requestBody);

      debugPrint('Response Body: $response');
      // Assume the response is a map, not a string
      if (response is Map<String, dynamic>) {
        // print('error here');
        debugPrint(response['message']);
        return response['message'] ?? 'Child Created Successfully';
      } else {
        return 'Unexpected response format';
      }
    } catch (e) {
      debugPrint('Exception: $e');
      rethrow;
    }
  }

  @override
  Future<bool> eagleridesAuthIsSignIn() async {
    var box = await Hive.openBox('authBox');
    final token = box.get('auth_token');
    print('Checking token');
    print(token);
    if (token != null) {
      // final response = await apiClient.get('/api/verify_token', params: {'token': token});
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> eagleridesAuthPhoneVerification(String phoneNumber) async {
    // return await auth.verifyPhoneNumber(
    //   phoneNumber: phoneNumber,
    //   verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {},
    //   verificationFailed: (FirebaseAuthException e) {
    //     Get.snackbar('error', e.code.toString(),
    //         snackPosition: SnackPosition.BOTTOM);
    //   },
    //   codeSent: (String verificationId, int? forceResendingToken) async {
    //     verId.value = verificationId;
    //     Get.closeAllSnackbars();
    //     Get.snackbar('done', "otp sent to $phoneNumber");
    //     // Get.to(() => const OtpVerificationPage());
    //   },
    //   codeAutoRetrievalTimeout: (String verificationId) async {},
    // );
  }

  @override
  Future<String> eagleridesAuthOtpVerification(String email, String otp) async {
    const uri = '/users/verify-mail';
    print('Sending OTP verification request...');
    print('testing');
    try {
      final response = await _client.post(
        uri,
        params: {
          'email': email.toString(),
          'otp': otp.toString(),
        },
      );

      debugPrint('Response Body: $response');
      // Assume the response is a map, not a string
      if (response is Map<String, dynamic>) {
        print('response here');
        debugPrint(response['message']);
        return response['message'];
      } else {
        return 'Unexpected response format';
      }
    } catch (e) {
      debugPrint('Exception: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getUser() async {
    const uri = '/users/current';
    try {
      // Making the GET request
      final response = await _client.get(uri);

      // Check if the response is null or invalid
      if (response == null) {
        throw Exception('Failed to get a valid response from the server.');
      }

      print('Response:');
      print(response); // Print the response body to see its contents

      // Check if the response status is OK (200)
      if (response.containsKey('user')) {
        final userInfo = response['user'] as Map<String, dynamic>;
        print('User Info: $userInfo');
        return userInfo;
      } else {
        // Handle non-200 status codes
        print('Error Response: ${response.body}');
        throw Exception('Failed to load user data: $response');
      }
    } catch (e) {
      // Catch any errors such as network issues, JSON decoding errors, etc.
      print('Exception caught: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchRates() async {
    const uri = '/rates';
    try {
      // Making the GET request
      final response = await _client.get(uri);

      // Check if the response is null or invalid
      if (response == null) {
        throw Exception('Failed to get a valid response from the server.');
      }

      print('Response:');
      print(response); // Print the response body to see its contents
      return response as Map<String, dynamic>;
    } catch (e) {
      // Catch any errors such as network issues, JSON decoding errors, etc.
      print('Exception caught: $e');
      rethrow;
    }
  }

  // @override
  // Future<List<Map<String, dynamic>>> fetchChildren(String userId) async {
  //   const baseUri = '/users/children';
  //   final uri = '$baseUri/$userId';

  //   try {
  //     print('Fetching children for userId: $userId');

  //     // Ensure we are calling a function that returns decoded JSON, not Response
  //     final data = await _client.get(uri);

  //     print('Fetched data: $data');

  //     if (data is List) {
  //       return List<Map<String, dynamic>>.from(data);
  //     } else {
  //       throw Exception(
  //           'Unexpected response format: Expected List, got ${data.runtimeType}');
  //     }
  //   } catch (e) {
  //     print('Error fetching children: $e');
  //     rethrow;
  //   }
  // }

  @override
  Future<List<Map<String, dynamic>>> fetchChildren(String userId) async {
    const baseUri = '/users/children';
    final uri = '$baseUri/$userId';

    try {
      print('Fetching children for userId: $userId');

      final data = await _client.get(uri);
      print('Fetched data: $data');

      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else if (data is Map<String, dynamic> && data.containsKey('message')) {
        print('No children found: ${data['message']}');
        return []; // Return an empty list instead of throwing an error
      } else {
        return [];
        // throw Exception(
        //     'Unexpected response format: Expected List, got ${data.runtimeType}');
      }
    } catch (e) {
      print('Error fetching children: $e');
      return []; // Ensure an empty list is returned on error
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRecentRides(String childId) async {
    const baseUri = '/book/rides/recent';
    final uri = '$baseUri/$childId'; // Make sure the URI is properly parsed
    try {
      print('Fetching recent rides for childId: $childId');
      final response = await _client.get(uri);
      print(response);

      // print(response.statusCode);
      // print(response);
      // print(List<Map<String, dynamic>>.from(response['bookings']));
      // var responseData =
      //       jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(response['bookings'] ?? []);
      // if (response.statusCode == 404) {
      //   print('No recent rides found.');
      //   return [];
      // }

      // // Decode the response body from String to Map<String, dynamic>
      // if (response.statusCode == 200) {
      //   var responseData =
      //       jsonDecode(response.body); // Decode the JSON response

      //   print('Fetched data: $responseData');

      //   // Assuming the response contains a 'bookings' key with the rides data
      //   return List<Map<String, dynamic>>.from(responseData['bookings'] ?? []);
      // } else {
      //   throw Exception('Failed to load recent rides');
      // }
    } catch (e) {
      print("Error fetching recent rides: $e");
      // rethrow; // Re-throw error to be handled elsewhere
      return [];
    }
  }

  @override
  Future<String> eagleridesAuthGetUserUid() async {
    return 'auth.currentUser!.uid';
  }

  @override
  Future<bool> eagleridesAuthCheckUserStatus(String userId) async {
    final response =
        await _client.get('/checkUserStatus', params: {'userId': userId});
    return response['status'] == 'active'; // Adjust based on your API response
  }

  @override
  Future<void> eagleridesAuthSignOut() async {
    try {
      final box = await Hive.openBox('authBox');
      final rateBox = await Hive.openBox('rateBox');
      final childrenBox = await Hive.openBox('childrenBox');

      // Logout API call (optional)
      final response = await _client.post(
        '/users/logout',
        params: {},
      );
      // Clear the token from storage
      await box.delete('auth_token');
      await box.clear();
      await rateBox.clear();
      await childrenBox.clear();
      // // Clear the token in GetIt
      // sl.unregister<ApiClient>(); // Unregister ApiClient
      // sl.registerLazySingleton<ApiClient>(() {
      //   return ApiClient(sl<Client>(), null); // Register with null token
      // });
      final token = box.get('auth_token');
      print('Token after logout: $token');
      print('Logout Response: $response');
    } catch (error) {
      print('Logout Error: $error');
      rethrow;
    }
  }

  @override
  Future<String> eagleridesAddProfileImg(String riderId) async {
    // final profileImage =
    //     await ImagePicker().pickImage(source: ImageSource.gallery);
    // File _profileImage = File(profileImage!.path);
    // await firebaseStorage
    //     .ref('UserProfileImages/$riderId')
    //     .putFile(_profileImage);
    // return await firebaseStorage
    //     .ref('UserProfileImages/$riderId')
    //     .getDownloadURL();
    return '';
  }
}
