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
  Future<List<Map<String, dynamic>>> fetchChildren(String userId) async {
    const baseUri = '/users/children';
    final uri = '$baseUri/$userId';

    try {
      print('Fetching children for userId: $userId');
      final response = await _client.get(uri);

      // if (response.statusCode == 200) {
      //   // Parse the response body and return a list of children
      //   return List<Map<String, dynamic>>.from(response.body);
      //   // return List<Child>.from(
      //   //     json.decode(response.body).map((x) => Child.fromJson(x)));
      // } else if (response.statusCode == 404) {
      //   // Return an empty list if no children found (404)
      //   return [];
      // } else {
      //   throw Exception('Failed to fetch children: ${response.body}');
      // }
      // Handle 404 error when no children are found
      if (response.statusCode == 404) {
        return []; // Return an empty list if no children found
      }

      if (response.statusCode == 200) {
        // Parse the response body to a list of maps
        List<dynamic> data = json.decode(response.body);
        // print('data');
        // print(data);
        // print('data two');
        // print(List<Map<String, dynamic>>.from(data));
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to fetch children: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching children: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRecentRides(String childId) async {
    const baseUri = '/book/rides/recent';
    final uri = '$baseUri/$childId'; // Make sure the URI is properly parsed
    try {
      print('Fetching recent rides for childId: $childId');
      final response = await _client.get(uri);

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
      rethrow; // Re-throw error to be handled elsewhere
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

      // Logout API call (optional)
      final response = await _client.post(
        '/users/logout',
        params: {},
      );
      // Clear the token from storage
      await box.delete('auth_token');
      await box.clear();
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
