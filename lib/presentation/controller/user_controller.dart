// import 'package:get/get.dart';
// import 'package:hive/hive.dart';

// import '../../data/models/user_model.dart';

// class UserController extends GetxController {
//   var user = Rx<UserModel?>(null); // Holds the logged-in user's data

//   @override
//   void onInit() {
//     super.onInit();
//     _loadUser();
//   }

//   // Method to update the user.
//   void setUser(UserModel userModel) {
//     user.value = userModel; // This updates the observable user.
//   }

//   Future<void> _loadUser() async {
//     var box = await Hive.openBox('authBox');
//     String? token = box.get('auth_token');
//     if (token != null) {
//       // If token exists, load the user data
//       var userInfo = box.get('user_info');
//       if (userInfo != null) {
//         user.value = UserModel.fromMap(
//             userInfo); // User.fromMap is a method that converts the data into a User object
//       }
//     }
//   }

//   // Future<void> logout() async {
//   //   var box = await Hive.openBox('authBox');
//   //   await box.clear(); // Clear the auth box when logging out
//   //   user.value = null; // Clear the user data from memory
//   // }
// }
