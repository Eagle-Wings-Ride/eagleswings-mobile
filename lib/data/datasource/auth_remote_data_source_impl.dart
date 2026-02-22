import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../injection_container.dart';
import '../core/api_client.dart';
import '../models/child_upsert_request.dart';
import '../models/payment_models.dart';
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
  Future<String> bookRide(
      Map<String, dynamic> requestBody, String childId) async {
    try {
      // Use /book/$childId as per Postman collection
      final uri = '/book/$childId';

      final body = Map<String, dynamic>.from(requestBody);
      body['childId'] = childId;

      final response = await _client.post(uri, params: body);

      debugPrint('Response Body: $response');

      // ⭐ RETURN THE ENTIRE RESPONSE AS JSON STRING
      if (response is Map<String, dynamic>) {
        // Convert the map back to JSON string so it can be parsed later
        return json.encode(response); // ✅ Return full JSON
      } else if (response is String) {
        return response; // Already a string
      } else {
        return json.encode({'error': 'Unexpected response format'});
      }
    } catch (e) {
      debugPrint('Exception: $e');
      rethrow;
    }
  }

  @override
  Future<String> addChild(ChildUpsertRequest requestBody) async {
    const uri = '/users/child';

    try {
      final response = await _client.postMultipart(
        uri,
        fields: requestBody.toFormFields(),
        file: requestBody.imageFile,
      );

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
  Future<void> eagleridesAuthPhoneVerification(String phoneNumber) async {}

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
        // Handle error case - response doesn't contain 'user' key
        final errorMessage = response['message'] ?? 'Unknown error occurred';
        print('Error Response: $errorMessage');
        throw Exception('Failed to load user data: $errorMessage');
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

  @override
  Future<List<Map<String, dynamic>>> fetchChildren() async {
    const uri = '/users/children/me';

    try {
      print('Fetching children for current user');

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

      return List<Map<String, dynamic>>.from(response['bookings'] ?? []);
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
    return '';
  }

  // ⭐ ADD THESE METHODS TO YOUR auth_remote_data_source_impl.dart
// Based on YOUR ACTUAL API documentation

  @override
  Future<List<Map<String, dynamic>>> fetchAllRides() async {
    // ⭐ CORRECT ENDPOINT: GET /book/rides/
    // This returns ALL rides for the authenticated user
    const uri = '/book/rides/';

    try {
      print('Fetching all rides for current user');

      final response = await _client.get(uri);
      print('Fetched rides response: $response');

      // Based on your API doc: response has 'rides' key
      if (response is Map<String, dynamic> && response.containsKey('rides')) {
        return List<Map<String, dynamic>>.from(response['rides'] ?? []);
      }
      // If no rides found
      else if (response is Map<String, dynamic> &&
          response.containsKey('message')) {
        print('No rides found: ${response['message']}');
        return [];
      }
      // If response is directly a list
      else if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }

      // Default to empty list if format is unexpected
      print('Unexpected response format for rides');
      return [];
    } catch (e) {
      print('Error fetching all rides: $e');
      return []; // Return empty list on error, matching your pattern
    }
  }

  @override
  Future<String> cancelRide(String bookingId, String cancelReason) async {
    try {
      print('Cancelling ride: $bookingId with reason: $cancelReason');

      final result = await updateRideStatus(bookingId, 'cancelled');
      return result['message'] ?? 'Ride cancelled successfully';
    } catch (e) {
      debugPrint('Exception cancelling ride: $e');
      rethrow;
    }
  }

  // ============================================
  // NEW: Payment Endpoints
  // ============================================

  @override
  Future<PaymentResponseModel> makePayment(PaymentRequestModel request) async {
    const uri = '/book/rides/make-payment/';
    try {
      print('Making payment for booking: ${request.bookingId}');

      final response = await _client.post(
        uri,
        params: request.toJson(),
      );

      debugPrint('Payment Response: $response');

      if (response is Map<String, dynamic>) {
        return PaymentResponseModel.fromJson(response);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      debugPrint('Exception making payment: $e');
      rethrow;
    }
  }

  @override
  Future<PaymentResponseModel> renewPayment(PaymentRequestModel request) async {
    const uri = '/book/rides/renew-payment/';
    try {
      print('Renewing payment for booking: ${request.bookingId}');

      final response = await _client.post(
        uri,
        params: request.toJson(),
      );

      debugPrint('Renew Payment Response: $response');

      if (response is Map<String, dynamic>) {
        return PaymentResponseModel.fromJson(response);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      debugPrint('Exception renewing payment: $e');
      rethrow;
    }
  }

  // ============================================
  // NEW: Ride Status Endpoints
  // ============================================

  @override
  Future<List<dynamic>> fetchRidesByStatus(
      String childId, String status) async {
    final uri = '/book/rides/status/$childId/$status';
    try {
      print('Fetching rides for child $childId with status: $status');

      final response = await _client.get(uri);

      debugPrint('Rides by Status Response: $response');

      if (response is Map<String, dynamic> && response.containsKey('rides')) {
        return response['rides'] as List<dynamic>;
      } else if (response is Map<String, dynamic> &&
          response.containsKey('bookings')) {
        return response['bookings'] as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Exception fetching rides by status: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> updateRideStatus(
      String bookingId, String status) async {
    final uri = '/book/rides/status/$bookingId';
    try {
      print('Updating ride $bookingId to status: $status');

      final response = await _client.patch(
        uri,
        params: {'status': status},
      );

      debugPrint('Update Status Response: $response');

      if (response is Map<String, dynamic>) {
        return response;
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      debugPrint('Exception updating ride status: $e');
      rethrow;
    }
  }

  // ============================================
  // NEW: User Management Endpoints
  // ============================================

  @override
  Future<Map<String, dynamic>> updateUserProfile(
      String userId, Map<String, dynamic> updates) async {
    final uri = '/users/$userId';
    try {
      print('Updating user profile: $userId');

      final response = await _client.patch(uri, params: updates);

      debugPrint('Update Profile Response: $response');

      if (response is Map<String, dynamic>) {
        // Update local storage with new user data
        if (response.containsKey('user')) {
          var box = await Hive.openBox('authBox');
          await box.put('user_info', response['user']);
        }
        return response;
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      debugPrint('Exception updating user profile: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    final uri = '/users/$userId';
    try {
      print('Deleting user: $userId');

      await _client.delete(uri);

      // Clear local storage
      var box = await Hive.openBox('authBox');
      await box.clear();

      debugPrint('User deleted successfully');
    } catch (e) {
      debugPrint('Exception deleting user: $e');
      rethrow;
    }
  }

  // ============================================
  // NEW: Child Management Endpoints
  // ============================================

  @override
  Future<Map<String, dynamic>> updateChild(
      String childId, ChildUpsertRequest updates) async {
    final uri = '/users/child/$childId';
    try {
      print('Updating child: $childId');

      final response = await _client.patchMultipart(
        uri,
        fields: updates.toFormFields(),
        file: updates.imageFile,
      );

      debugPrint('Update Child Response: $response');

      if (response is Map<String, dynamic>) {
        return response;
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      debugPrint('Exception updating child: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteChild(String childId) async {
    final uri = '/users/child/$childId';
    try {
      print('Deleting child: $childId');

      await _client.delete(uri);

      debugPrint('Child deleted successfully');
    } catch (e) {
      debugPrint('Exception deleting child: $e');
      rethrow;
    }
  }

  // ============================================
  // NEW: Password Reset Endpoints
  // ============================================

  @override
  Future<String> forgotPassword({
    required String email,
    String? oldPassword,
    String? newPassword,
  }) async {
    const uri = '/users/forgot-password';
    try {
      print('Requesting password reset for: $email');

      final payload = <String, dynamic>{
        'email': email,
      };
      if (oldPassword != null && oldPassword.trim().isNotEmpty) {
        payload['oldPassword'] = oldPassword;
      }
      if (newPassword != null && newPassword.trim().isNotEmpty) {
        payload['newPassword'] = newPassword;
      }

      final response = await _client.post(
        uri,
        params: payload,
      );

      debugPrint('Forgot Password Response: $response');

      if (response is Map<String, dynamic>) {
        return response['message'] ?? 'Password reset email sent';
      } else {
        return 'Password reset email sent';
      }
    } catch (e) {
      debugPrint('Exception in forgot password: $e');
      rethrow;
    }
  }

  @override
  Future<String> resendOtp(String email) async {
    const uri = '/users/resend-otp';
    try {
      print('Resending OTP for: $email');

      final response = await _client.post(
        uri,
        params: {'email': email},
      );

      debugPrint('Resend OTP Response: $response');

      if (response is Map<String, dynamic>) {
        return response['message'] ?? 'OTP sent successfully';
      } else {
        return 'OTP sent successfully';
      }
    } catch (e) {
      debugPrint('Exception resending OTP: $e');
      rethrow;
    }
  }
}
