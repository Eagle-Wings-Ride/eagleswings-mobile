// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';

// import '../../../styles/styles.dart';
// import '../../controller/auth/auth_controller.dart';

// class DeleteAccountScreen extends StatefulWidget {
//   const DeleteAccountScreen({super.key});

//   @override
//   State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
// }

// class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
//   final AuthController _authController = Get.find();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _showDeleteConfirmationDialog() {
//     Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: Row(
//           children: [
//             Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
//             const SizedBox(width: 10),
//             Text(
//               'Delete Account?',
//               style: GoogleFonts.poppins(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 18,
//               ),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'This action cannot be undone!',
//               style: GoogleFonts.poppins(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.red,
//               ),
//             ),
//             const SizedBox(height: 15),
//             Text(
//               'Deleting your account will permanently remove:',
//               style: GoogleFonts.poppins(fontSize: 13),
//             ),
//             const SizedBox(height: 10),
//             ...[
//               'Your profile information',
//               'All registered children',
//               'Ride booking history',
//               'Payment information',
//               'All associated data',
//             ].map((item) => Padding(
//                   padding: const EdgeInsets.only(bottom: 6),
//                   child: Row(
//                     children: [
//                       Icon(Icons.check_circle,
//                           size: 16, color: Colors.red.withOpacity(0.7)),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           item,
//                           style: GoogleFonts.poppins(fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )),
//             const SizedBox(height: 15),
//             Text(
//               'Please enter your password to confirm:',
//               style: GoogleFonts.poppins(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: 'Enter password',
//                 hintStyle: GoogleFonts.poppins(fontSize: 13),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 15,
//                   vertical: 12,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               _passwordController.clear();
//               Get.back();
//             },
//             child: Text(
//               'Cancel',
//               style: GoogleFonts.poppins(
//                 color: textColor.withOpacity(0.6),
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (_passwordController.text.isEmpty) {
//                 Get.snackbar(
//                   'Error',
//                   'Please enter your password',
//                   snackPosition: SnackPosition.BOTTOM,
//                   backgroundColor: Colors.red,
//                   colorText: Colors.white,
//                 );
//                 return;
//               }
//               Get.back();
//               _deleteAccount();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text(
//               'Delete Account',
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _deleteAccount() async {
//     setState(() => _isLoading = true);

//     try {
//       // TODO: Implement actual delete account API call
//       await _authController.deleteAccount(
//         _passwordController.text,
//         context,
//       );

//       _passwordController.clear();
//       setState(() => _isLoading = false);
//     } catch (e) {
//       setState(() => _isLoading = false);
//       Get.snackbar(
//         'Error',
//         'Failed to delete account: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           'Delete Account',
//           style: GoogleFonts.poppins(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Warning Icon
//                 Center(
//                   child: Container(
//                     padding: const EdgeInsets.all(30),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.delete_forever,
//                       size: 80,
//                       color: Colors.red,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),

//                 // Warning Title
//                 Text(
//                   'Before You Go...',
//                   style: GoogleFonts.poppins(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: textColor,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'We\'re sorry to see you leave. Please note that deleting your account is permanent and cannot be undone.',
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     color: textColor.withOpacity(0.7),
//                     height: 1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 30),

//                 // What Gets Deleted
//                 _buildInfoCard(
//                   title: 'What Gets Deleted',
//                   icon: Iconsax.info_circle,
//                   iconColor: Colors.red,
//                   items: [
//                     'All your personal information',
//                     'Registered children profiles',
//                     'Ride booking history',
//                     'Payment methods and history',
//                     'Account preferences',
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 // What Happens Next
//                 _buildInfoCard(
//                   title: 'What Happens Next',
//                   icon: Iconsax.clock,
//                   iconColor: Colors.orange,
//                   items: [
//                     'Your data will be deleted within 30 days',
//                     'You\'ll receive a confirmation email',
//                     'Active rides will be cancelled',
//                     'Refunds will be processed (if applicable)',
//                     'You can create a new account anytime',
//                   ],
//                 ),
//                 const SizedBox(height: 30),

//                 // Alternative Options
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(15),
//                     border: Border.all(
//                       color: Colors.blue.withOpacity(0.3),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Iconsax.information, 
//                             color: Colors.blue,
//                             size: 20
//                           ),
//                           const SizedBox(width: 10),
//                           Text(
//                             'Consider These Alternatives',
//                             style: GoogleFonts.poppins(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         '• Temporarily disable your account\n'
//                         '• Update your privacy settings\n'
//                         '• Contact support for assistance',
//                         style: GoogleFonts.poppins(
//                           fontSize: 13,
//                           color: textColor.withOpacity(0.8),
//                           height: 1.6,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 40),

//                 // Delete Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                     ),
//                     onPressed: _showDeleteConfirmationDialog,
//                     child: Text(
//                       'Delete My Account',
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),

//                 // Cancel Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       side: BorderSide(color: backgroundColor),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                     ),
//                     onPressed: () => Get.back(),
//                     child: Text(
//                       'Keep My Account',
//                       style: GoogleFonts.poppins(
//                         color: backgroundColor,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//           if (_isLoading)
//             Container(
//               color: Colors.black54,
//               child: const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCard({
//     required String title,
//     required IconData icon,
//     required Color iconColor,
//     required List<String> items,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           color: Colors.grey[200]!,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: iconColor, size: 20),
//               const SizedBox(width: 10),
//               Text(
//                 title,
//                 style: GoogleFonts.poppins(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: textColor,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           ...items.map((item) => Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(
//                       Icons.check_circle_outline,
//                       size: 16,
//                       color: iconColor.withOpacity(0.7),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Text(
//                         item,
//                         style: GoogleFonts.poppins(
//                           fontSize: 13,
//                           color: textColor.withOpacity(0.8),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }
