
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/api_client.dart';
import 'auth_remote_data_source.dart';

class EagleRidesAuthDataSourceImpl extends EagleRidesAuthDataSource {
  var verId = "".obs;
  final ApiClient _client;

  EagleRidesAuthDataSourceImpl(this._client);

  // @override
  // Future<ResponseModel> validateWithLogin(
  //     Map<String, dynamic> requestBody) async {
  //   final response = await _client.post(
  //     'authentication/token/validate_with_login',
  //     params: requestBody,
  //   );
  //   print(response);
  //   return ResponseModel(response, true);
  // }

  @override
  Future<String> loginUser(String email, String password) async {
    const uri = 'https://your-backend-url.com/api/login';
    final response = await _client.post(
      uri,
      params: {'email': email, 'password': password},
      // headers: {'Content-Type': 'application/json'},
    );
    if (response['token'] != null) {
      var box = await Hive.openBox('authBox');
      await box.put('auth_token', response['token']);
      return response['token'];
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Future<bool> eagleridesAuthIsSignIn() async {
    var box = await Hive.openBox('authBox');
    final token = box.get('auth_token');
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
  Future<void> eagleridesAuthOtpVerification(String otp) async {
    // try {
    //   final AuthCredential authCredential = PhoneAuthProvider.credential(
    //       verificationId: verId.value, smsCode: otp);
    //   await auth.signInWithCredential(authCredential);
    //   // Get.to(() => const UberHomePage());
    // } on FirebaseAuthException catch (e) {
    //   Get.snackbar('error', e.code.toString());
    // }
  }

  @override
  Future<String> eagleridesAuthGetUserUid() async {
    return 'auth.currentUser!.uid';
  }

  @override
  Future<bool> eagleridesAuthCheckUserStatus(String userId) async {
     final response = await _client.get('/checkUserStatus', params: {'userId': userId});
    return response['status'] == 'active'; // Adjust based on your API response
 
  }

  @override
  Future<void> eagleridesAuthSignOut() async {
    // return await auth.signOut();
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
