import 'dart:convert';

import 'package:eaglerides/data/models/register_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../presentation/screens/auth/login.dart';
import '../core/api_client.dart';
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
        // Decode the JSON response body
        // final Map<String, dynamic> userInfo = jsonDecode(response.body);

        // // Optionally, check the response structure
        // if (userInfo.containsKey('message')) {
        //   print('Message: ${userInfo['message']}');
        // }

        // // Return the decoded user data
        // return userInfo;
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
  Future<String> eagleridesAuthGetUserUid() async {
    return 'auth.currentUser!.uid';
  }

  // @override
  // Future<String> getUser() async {
  //   // try {
  //   //   object
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //   return '';
  // }

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

      // Ensure token is included in headers
      final response = await _client.post(
        '/users/logout',
        params: {}, // If logout doesn't require params, pass an empty map
      );

      print('Logout Response: $response');

      // Clear token and navigate to login
      await box.delete('auth_token');
      await box.clear();
      final token = box.get('auth_token');
      print(token);
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   '/login',
      //   (route) => false,
      // );
    } catch (error) {
      print('Logout Error: $error');
      rethrow;
      // Optionally show error message to the user
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
