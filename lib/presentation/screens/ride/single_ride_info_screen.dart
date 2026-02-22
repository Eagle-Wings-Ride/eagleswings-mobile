// import 'dart:async';
// import 'dart:math';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';

// import '../../../core/utils/format_date.dart';
// import '../../../core/utils/get_status.dart';
// import '../../../data/models/book_rides_model.dart';
// import '../../../styles/styles.dart';
// import '../../controller/auth/auth_controller.dart';

// class SingleRideInfoScreen extends StatefulWidget {
//   const SingleRideInfoScreen({super.key});

//   @override
//   State<SingleRideInfoScreen> createState() => _SingleRideInfoScreenState();
// }

// class _SingleRideInfoScreenState extends State<SingleRideInfoScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//   late final AuthController _authController;

//   BitmapDescriptor? _pickupIcon;
//   BitmapDescriptor? _dropOffIcon;
//   Booking? _ride;
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _initializeScreen();
//   }

//   /// Initialize screen data
//   Future<void> _initializeScreen() async {
//     try {
//       // Get AuthController safely
//       if (Get.isRegistered<AuthController>()) {
//         _authController = Get.find<AuthController>();
//       } else {
//         throw Exception('AuthController not found');
//       }

//       // Load custom markers
//       await _loadCustomMarkers();

//       // Get ride from arguments
//       final arguments = Get.arguments;
//       if (arguments == null || !arguments.containsKey('rideId')) {
//         throw Exception('Ride ID not provided');
//       }

//       final rideId = arguments['rideId'];

//       // Find the ride
//       if (_authController.recentRides.isEmpty) {
//         throw Exception('No rides available');
//       }

//       final foundRide = _authController.recentRides.firstWhereOrNull(
//         (r) => r.id == rideId,
//       );

//       if (foundRide == null) {
//         throw Exception('Ride not found');
//       }

//       setState(() {
//         _ride = foundRide;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//       print('Error initializing screen: $e');
//     }
//   }

//   /// Load custom marker icons
//   Future<void> _loadCustomMarkers() async {
//     try {
//       final Uint8List pickupMarker =
//           await _getBytesFromAsset('assets/images/pickupmarker.png', 85);
//       final Uint8List dropOffMarker =
//           await _getBytesFromAsset('assets/images/dropmarker.png', 85);

//       setState(() {
//         _pickupIcon = BitmapDescriptor.fromBytes(pickupMarker);
//         _dropOffIcon = BitmapDescriptor.fromBytes(dropOffMarker);
//       });
//     } catch (e) {
//       print('Error loading markers: $e');
//       // Use default markers if custom ones fail
//       setState(() {
//         _pickupIcon = BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueGreen,
//         );
//         _dropOffIcon = BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueRed,
//         );
//       });
//     }
//   }

//   /// Convert asset to bytes for custom markers
//   Future<Uint8List> _getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(
//       data.buffer.asUint8List(),
//       targetWidth: width,
//     );
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   /// Get status message based on ride status
//   String _getStatusMessage(String status) {
//     switch (status.toLowerCase()) {
//       case 'booked':
//         return 'Your Trip has been Booked';
//       case 'completed':
//         return 'Trip Completed Successfully';
//       case 'cancelled':
//         return 'Trip was Cancelled';
//       case 'ongoing':
//         return 'Trip is in Progress';
//       default:
//         return 'Status: ${status.capitalizeFirstInfo}';
//     }
//   }

//   /// Get status badge text
//   String _getStatusBadgeText(String status) {
//     switch (status.toLowerCase()) {
//       case 'booked':
//         return 'Booked';
//       case 'completed':
//         return 'Completed';
//       case 'cancelled':
//         return 'Cancelled';
//       case 'ongoing':
//         return 'In Progress';
//       default:
//         return status.capitalizeFirstInfo ?? 'Unknown';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return _buildLoadingScreen();
//     }

//     if (_errorMessage != null || _ride == null) {
//       return _buildErrorScreen();
//     }

//     return Scaffold(
//       body: SafeArea(
//         bottom: false,
//         child: Stack(
//           children: [
//             _buildMap(),
//             _buildRideDetailsSheet(),
//             _buildBackButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Build loading screen
//   Widget _buildLoadingScreen() {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Ride Details',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: backgroundColor,
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(color: backgroundColor),
//             const SizedBox(height: 20),
//             Text(
//               'Loading ride details...',
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 color: textColor.withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Build error screen
//   Widget _buildErrorScreen() {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Ride Details',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: backgroundColor,
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(40.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 size: 80,
//                 color: Colors.red.withOpacity(0.5),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Ride Not Found',
//                 style: GoogleFonts.poppins(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: textColor,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 _errorMessage ?? 'The requested ride could not be found',
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   color: textColor.withOpacity(0.6),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () => Get.back(),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: backgroundColor,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 15,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: Text(
//                   'Go Back',
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Build Google Map
//   Widget _buildMap() {
//     return Positioned.fill(
//       bottom: MediaQuery.of(context).size.height / 2.5,
//       child: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: CameraPosition(
//           target: LatLng(_ride!.endLatitude, _ride!.endLongitude),
//           zoom: 14,
//         ),
//         myLocationButtonEnabled: false,
//         myLocationEnabled: false,
//         compassEnabled: false,
//         buildingsEnabled: true,
//         markers: _buildMarkers(),
//         polylines: _buildPolylines(),
//         zoomControlsEnabled: false,
//         zoomGesturesEnabled: true,
//         onMapCreated: _onMapCreated,
//       ),
//     );
//   }

//   /// Build map markers
//   Set<Marker> _buildMarkers() {
//     final markers = <Marker>{};

//     if (_pickupIcon != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId("pickup"),
//           position: LatLng(_ride!.startLatitude, _ride!.startLongitude),
//           infoWindow: InfoWindow(
//             title: "Pickup",
//             snippet: _ride!.pickUpLocation,
//           ),
//           icon: _pickupIcon!,
//         ),
//       );
//     }

//     if (_dropOffIcon != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId("dropoff"),
//           position: LatLng(_ride!.endLatitude, _ride!.endLongitude),
//           infoWindow: InfoWindow(
//             title: "Drop-off",
//             snippet: _ride!.dropOffLocation,
//           ),
//           icon: _dropOffIcon!,
//         ),
//       );
//     }

//     return markers;
//   }

//   /// Build polylines
//   Set<Polyline> _buildPolylines() {
//     return {
//       Polyline(
//         polylineId: const PolylineId("route"),
//         visible: true,
//         color: backgroundColor,
//         width: 5,
//         jointType: JointType.round,
//         startCap: Cap.roundCap,
//         endCap: Cap.roundCap,
//         geodesic: true,
//         points: [
//           LatLng(_ride!.startLatitude, _ride!.startLongitude),
//           LatLng(_ride!.endLatitude, _ride!.endLongitude),
//         ],
//       ),
//     };
//   }

//   /// Handle map creation
//   Future<void> _onMapCreated(GoogleMapController controller) async {
//     _controller.complete(controller);

//     // Calculate bounds to show both markers
//     final bounds = _calculateBounds(
//       LatLng(_ride!.startLatitude, _ride!.startLongitude),
//       LatLng(_ride!.endLatitude, _ride!.endLongitude),
//     );

//     // Animate camera to fit bounds
//     Future.delayed(const Duration(milliseconds: 500), () async {
//       final mapController = await _controller.future;
//       mapController.animateCamera(
//         CameraUpdate.newLatLngBounds(bounds, 80),
//       );
//     });
//   }

//   /// Calculate bounds for two locations
//   LatLngBounds _calculateBounds(LatLng point1, LatLng point2) {
//     return LatLngBounds(
//       southwest: LatLng(
//         min(point1.latitude, point2.latitude),
//         min(point1.longitude, point2.longitude),
//       ),
//       northeast: LatLng(
//         max(point1.latitude, point2.latitude),
//         max(point1.longitude, point2.longitude),
//       ),
//     );
//   }

//   /// Build draggable ride details sheet
//   Widget _buildRideDetailsSheet() {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.5,
//       minChildSize: 0.4,
//       maxChildSize: 0.85,
//       builder: (context, scrollController) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(25),
//               topRight: Radius.circular(25),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 10,
//                 offset: Offset(0, -5),
//               ),
//             ],
//           ),
//           child: SingleChildScrollView(
//             controller: scrollController,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildDragHandle(),
//                   const SizedBox(height: 20),
//                   _buildStatusHeader(),
//                   const SizedBox(height: 25),
//                   _buildDriverInfo(),
//                   const SizedBox(height: 25),
//                   _buildTripDetails(),
//                   const SizedBox(height: 20),
//                   _buildActionButtons(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   /// Build drag handle
//   Widget _buildDragHandle() {
//     return Center(
//       child: Container(
//         width: 50,
//         height: 5,
//         decoration: BoxDecoration(
//           color: Colors.grey[300],
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }

//   /// Build status header
//   Widget _buildStatusHeader() {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             _getStatusMessage(_ride!.status),
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: textColor,
//             ),
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: getStatusColor(_ride!.status.toLowerCase()).withOpacity(0.15),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(
//             _getStatusBadgeText(_ride!.status),
//             style: GoogleFonts.poppins(
//               fontSize: 12,
//               color: getStatusColor(_ride!.status.toLowerCase()),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   /// Build driver info card (placeholder - replace with actual driver data)
//   Widget _buildDriverInfo() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: backgroundColor.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           color: backgroundColor.withOpacity(0.1),
//         ),
//       ),
//       child: Row(
//         children: [
//           // Driver Avatar
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: backgroundColor.withOpacity(0.2),
//               image: const DecorationImage(
//                 image: AssetImage('assets/images/account_icon.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(width: 15),
//           // Driver Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Driver Assignment',
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: textColor,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   _ride!.status.toLowerCase() == 'booked'
//                       ? 'Driver will be assigned soon'
//                       : 'Driver assigned',
//                   style: GoogleFonts.poppins(
//                     fontSize: 12,
//                     color: textColor.withOpacity(0.6),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build trip details card
//   Widget _buildTripDetails() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Trip Details',
//             style: GoogleFonts.poppins(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: textColor,
//             ),
//           ),
//           const SizedBox(height: 20),
//           _buildLocationRow(
//             icon: Icons.radio_button_checked,
//             iconColor: Colors.green,
//             label: 'Pickup',
//             value: _ride!.pickUpLocation,
//           ),
//           const SizedBox(height: 15),
//           _buildLocationRow(
//             icon: Icons.location_on,
//             iconColor: Colors.red,
//             label: 'Drop-off',
//             value: _ride!.dropOffLocation,
//           ),
//           const SizedBox(height: 20),
//           Divider(color: greyColor),
//           const SizedBox(height: 15),
//           _buildDetailRow(
//             icon: Icons.access_time,
//             label: 'Pickup Time',
//             value: _ride!.pickUpTime,
//           ),
//           const SizedBox(height: 12),
//           _buildDetailRow(
//             icon: Icons.access_time_filled,
//             label: 'Drop-off Time',
//             value: _ride!.dropOffTime,
//           ),
//           const SizedBox(height: 12),
//           _buildDetailRow(
//             icon: Icons.calendar_today,
//             label: 'Date',
//             value: formatDate(_ride!.createdAt),
//           ),
//           const SizedBox(height: 20),
//           Divider(color: greyColor),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildBadge(
//                   label: _ride!.rideType == 'inhouse'
//                       ? 'In-House Driver'
//                       : 'Freelance Driver',
//                   color: getRideTypeColor(_ride!.rideType),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: _buildBadge(
//                   label: _ride!.tripType == 'oneway' ? 'One Way' : 'Return',
//                   color: const Color(0xff133BB7),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build location row
//   Widget _buildLocationRow({
//     required IconData icon,
//     required Color iconColor,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: iconColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: iconColor, size: 20),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: GoogleFonts.poppins(
//                   fontSize: 12,
//                   color: textColor.withOpacity(0.6),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   color: textColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   /// Build detail row
//   Widget _buildDetailRow({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: textColor.withOpacity(0.6)),
//         const SizedBox(width: 10),
//         Text(
//           '$label:',
//           style: GoogleFonts.poppins(
//             fontSize: 13,
//             color: textColor.withOpacity(0.6),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             value,
//             style: GoogleFonts.poppins(
//               fontSize: 13,
//               color: textColor,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   /// Build badge
//   Widget _buildBadge({required String label, required Color color}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         label,
//         textAlign: TextAlign.center,
//         style: GoogleFonts.poppins(
//           fontSize: 11,
//           color: color,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   /// Build action buttons
//   Widget _buildActionButtons() {
//     // Only show cancel button if ride is booked
//     if (_ride!.status.toLowerCase() == 'booked') {
//       return Column(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 _showCancelConfirmation();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               icon: const Icon(Icons.cancel, color: Colors.white),
//               label: Text(
//                 'Cancel Ride',
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton.icon(
//               onPressed: () {
//                 // TODO: Contact driver
//                 Get.snackbar(
//                   'Coming Soon',
//                   'Contact driver feature will be available soon',
//                   snackPosition: SnackPosition.BOTTOM,
//                 );
//               },
//               style: OutlinedButton.styleFrom(
//                 side: BorderSide(color: backgroundColor),
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               icon: Icon(Icons.phone, color: backgroundColor),
//               label: Text(
//                 'Contact Support',
//                 style: GoogleFonts.poppins(
//                   color: backgroundColor,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     return const SizedBox.shrink();
//   }

//   /// Show cancel confirmation dialog
//   void _showCancelConfirmation() {
//     Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: Text(
//           'Cancel Ride?',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         content: Text(
//           'Are you sure you want to cancel this ride? This action cannot be undone.',
//           style: GoogleFonts.poppins(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text(
//               'No, Keep it',
//               style: GoogleFonts.poppins(
//                 color: textColor.withOpacity(0.6),
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               // TODO: Implement cancel ride API call
//               Get.snackbar(
//                 'Ride Cancelled',
//                 'Your ride has been cancelled successfully',
//                 snackPosition: SnackPosition.BOTTOM,
//                 backgroundColor: Colors.red.withOpacity(0.8),
//                 colorText: Colors.white,
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             child: Text(
//               'Yes, Cancel',
//               style: GoogleFonts.poppins(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build back button
//   Widget _buildBackButton() {
//     return Positioned(
//       top: 15,
//       left: 15,
//       child: GestureDetector(
//         onTap: () => Get.back(),
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: const Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.black,
//             size: 20,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/utils/format_date.dart';
import '../../../core/utils/get_status.dart';
import '../../../core/utils/string_extensions.dart'; // ⭐ ADDED THIS FIX
import '../../../data/models/book_rides_model.dart';
import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';
import 'live_tracking_screen.dart' show LiveTrackingScreen;

class SingleRideInfoScreen extends StatefulWidget {
  const SingleRideInfoScreen({super.key});

  @override
  State<SingleRideInfoScreen> createState() => _SingleRideInfoScreenState();
}

class _SingleRideInfoScreenState extends State<SingleRideInfoScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late final AuthController _authController;

  BitmapDescriptor? _pickupIcon;
  BitmapDescriptor? _dropOffIcon;
  Booking? _ride;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    try {
      if (Get.isRegistered<AuthController>()) {
        _authController = Get.find<AuthController>();
      } else {
        throw Exception('AuthController not found');
      }

      await _loadCustomMarkers();

      final arguments = Get.arguments;
      if (arguments == null || !arguments.containsKey('rideId')) {
        throw Exception('Ride ID not provided');
      }

      final rideId = arguments['rideId'];

      if (_authController.recentRides.isEmpty) {
        throw Exception('No rides available');
      }

      final foundRide = _authController.recentRides.firstWhereOrNull(
        (r) => r.id == rideId,
      );

      if (foundRide == null) {
        throw Exception('Ride not found');
      }

      setState(() {
        _ride = foundRide;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print('Error initializing screen: $e');
    }
  }

  Future<void> _loadCustomMarkers() async {
    try {
      final Uint8List pickupMarker =
          await _getBytesFromAsset('assets/images/pickupmarker.png', 85);
      final Uint8List dropOffMarker =
          await _getBytesFromAsset('assets/images/dropmarker.png', 85);

      setState(() {
        _pickupIcon = BitmapDescriptor.fromBytes(pickupMarker);
        _dropOffIcon = BitmapDescriptor.fromBytes(dropOffMarker);
      });
    } catch (e) {
      print('Error loading markers: $e');
      setState(() {
        _pickupIcon = BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        );
        _dropOffIcon = BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        );
      });
    }
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_errorMessage != null || _ride == null) {
      return _buildErrorScreen();
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            _buildMap(),
            _buildRideDetailsSheet(),
            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ride Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: backgroundColor),
            const SizedBox(height: 20),
            Text(
              'Loading ride details...',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ride Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red.withOpacity(0.5),
              ),
              const SizedBox(height: 20),
              Text(
                'Ride Not Found',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _errorMessage ?? 'The requested ride could not be found',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: textColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Go Back',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Positioned.fill(
      bottom: MediaQuery.of(context).size.height / 2.5,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            double.parse(_ride!.endLatitude),
            double.parse(_ride!.endLongitude),
          ),
          zoom: 14,
        ),
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        compassEnabled: false,
        buildingsEnabled: true,
        markers: _buildMarkers(),
        polylines: _buildPolylines(),
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    if (_pickupIcon != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: LatLng(
            double.parse(_ride!.startLatitude),
            double.parse(_ride!.startLongitude),
          ),
          infoWindow: InfoWindow(
            title: "Pickup",
            snippet: _ride!.mainPickupAddress,
          ),
          icon: _pickupIcon!,
        ),
      );
    }

    if (_dropOffIcon != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("dropoff"),
          position: LatLng(
            double.parse(_ride!.endLatitude),
            double.parse(_ride!.endLongitude),
          ),
          infoWindow: InfoWindow(
            title: "Drop-off",
            snippet: _ride!.mainDropoffAddress,
          ),
          icon: _dropOffIcon!,
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    return {
      Polyline(
        polylineId: const PolylineId("route"),
        visible: true,
        color: backgroundColor,
        width: 5,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        points: [
          LatLng(
            double.parse(_ride!.startLatitude),
            double.parse(_ride!.startLongitude),
          ),
          LatLng(
            double.parse(_ride!.endLatitude),
            double.parse(_ride!.endLongitude),
          ),
        ],
      ),
    };
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);

    final bounds = _calculateBounds(
      LatLng(
        double.parse(_ride!.startLatitude),
        double.parse(_ride!.startLongitude),
      ),
      LatLng(
        double.parse(_ride!.endLatitude),
        double.parse(_ride!.endLongitude),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () async {
      final mapController = await _controller.future;
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 80),
      );
    });
  }

  LatLngBounds _calculateBounds(LatLng point1, LatLng point2) {
    return LatLngBounds(
      southwest: LatLng(
        min(point1.latitude, point2.latitude),
        min(point1.longitude, point2.longitude),
      ),
      northeast: LatLng(
        max(point1.latitude, point2.latitude),
        max(point1.longitude, point2.longitude),
      ),
    );
  }

  Widget _buildRideDetailsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDragHandle(),
                  const SizedBox(height: 20),
                  _buildStatusHeader(),
                  const SizedBox(height: 25),
                  if (_ride!.hasDrivers) ...[
                    _buildDriversSection(),
                    const SizedBox(height: 25),
                  ],
                  _buildChildSection(),
                  const SizedBox(height: 25),
                  _buildTripDetails(),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _getStatusMessage(_ride!.status),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color:
                getStatusColor(_ride!.status.toLowerCase()).withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _ride!.status,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: getStatusColor(_ride!.status.toLowerCase()),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriversSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: backgroundColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.driver, color: backgroundColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Assigned Driver${_ride!.drivers.length > 1 ? 's' : ''}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._ride!.drivers.map((driver) => _buildDriverCard(driver)).toList(),
        ],
      ),
    );
  }

  Widget _buildDriverCard(driver) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor.withOpacity(0.2),
              image: driver.image != null
                  ? DecorationImage(
                      image: NetworkImage(driver.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: driver.image == null
                ? Center(
                    child: Text(
                      driver.fullname.isNotEmpty
                          ? driver.fullname[0].toUpperCase()
                          : 'D',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: backgroundColor,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.fullname,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: driver.isAvailable
                        ? Colors.green.withOpacity(0.15)
                        : Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    driver.status,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: driver.isAvailable ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: backgroundColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor.withOpacity(0.2),
              image: _ride!.child.image != null
                  ? DecorationImage(
                      image: NetworkImage(_ride!.child.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _ride!.child.image == null
                ? Center(
                    child: Text(
                      _ride!.child.fullname.isNotEmpty
                          ? _ride!.child.fullname[0].toUpperCase()
                          : 'C',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: backgroundColor,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _ride!.child.fullname,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_ride!.child.age} years old • Grade ${_ride!.child.grade} • ${_ride!.child.school}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_ride!.status.toLowerCase() == 'ongoing') ...[
            ElevatedButton.icon(
              onPressed: () {
                // ⭐ PASS THE WHOLE BOOKING OBJECT
                Get.to(() => LiveTrackingScreen(
                      bookingId: _ride!.id,
                      rideDetails: {
                        'booking':
                            _ride, // ⭐ This is the magic - pass real data!
                        'pickupLat': _ride!.startLatitude,
                        'pickupLng': _ride!.startLongitude,
                        'dropoffLat': _ride!.endLatitude,
                        'dropoffLng': _ride!.endLongitude,
                        'pickupAddress': _ride!.mainPickupAddress,
                        'dropoffAddress': _ride!.mainDropoffAddress,
                      },
                    ));
              },
              icon: Icon(Icons.location_on),
              label: Text('Track Live'),
            ),
          ],

          Text(
            'Trip Details',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),

          // Morning Trip
          if (_ride!.morningFromAddress != null) ...[
            _buildTripSection(
              title: 'Morning Trip',
              icon: Icons.wb_sunny_outlined,
              iconColor: Colors.orange,
              from: _ride!.morningFrom ?? 'N/A',
              to: _ride!.morningTo ?? 'N/A',
              time: _ride!.morningTime ?? 'N/A',
              fromAddress: _ride!.morningFromAddress!,
              toAddress: _ride!.morningToAddress ?? 'N/A',
            ),
          ],

          // Afternoon Trip
          if (_ride!.isReturnTrip && _ride!.afternoonFromAddress != null) ...[
            const SizedBox(height: 20),
            Divider(color: greyColor),
            const SizedBox(height: 20),
            _buildTripSection(
              title: 'Afternoon Trip',
              icon: Icons.nights_stay_outlined,
              iconColor: Colors.blue,
              from: _ride!.afternoonFrom ?? 'N/A',
              to: _ride!.afternoonTo ?? 'N/A',
              time: _ride!.afternoonTime ?? 'N/A',
              fromAddress: _ride!.afternoonFromAddress!,
              toAddress: _ride!.afternoonToAddress ?? 'N/A',
            ),
          ],

          const SizedBox(height: 20),
          Divider(color: greyColor),
          const SizedBox(height: 15),

          // Schedule Details
          _buildDetailRow(
            icon: Iconsax.calendar,
            label: 'Start Date',
            value: _ride!.startDate,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            icon: Iconsax.repeat,
            label: 'Schedule',
            value: _ride!.scheduleType,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            icon: Iconsax.clock,
            label: 'Pickup Days',
            value: _ride!.formattedPickupDays,
          ),

          const SizedBox(height: 20),
          Divider(color: greyColor),
          const SizedBox(height: 15),

          // Badges
          Row(
            children: [
              Expanded(
                child: _buildBadge(
                  label: _ride!.rideType == 'inhouse'
                      ? 'In-House Driver'
                      : 'Freelance Driver',
                  color: getRideTypeColor(_ride!.rideType),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildBadge(
                  label: _ride!.isReturnTrip ? 'Return Trip' : 'One Way',
                  color: const Color(0xff133BB7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String from,
    required String to,
    required String time,
    required String fromAddress,
    required String toAddress,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                time,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildLocationRow(
          icon: Icons.radio_button_checked,
          iconColor: Colors.green,
          label: from.capitalizeFirstInfo, // ⭐ NOW WORKS WITH STRING EXTENSION
          value: fromAddress,
        ),
        const SizedBox(height: 10),
        _buildLocationRow(
          icon: Icons.location_on,
          iconColor: Colors.red,
          label: to.capitalizeFirstInfo, // ⭐ NOW WORKS WITH STRING EXTENSION
          value: toAddress,
        ),
      ],
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: textColor.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: textColor.withOpacity(0.6)),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: textColor.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (_ride!.status.toLowerCase() == 'booked' ||
        _ride!.status.toLowerCase() == 'paid') {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showCancelConfirmation(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.cancel, color: Colors.white),
              label: Text(
                'Cancel Ride',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Get.snackbar(
                  'Coming Soon',
                  'Contact support feature will be available soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: backgroundColor),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: Icon(Icons.phone, color: backgroundColor),
              label: Text(
                'Contact Support',
                style: GoogleFonts.poppins(
                  color: backgroundColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _showCancelConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Cancel Ride?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to cancel this ride? This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'No, Keep it',
              style: GoogleFonts.poppins(
                color: textColor.withOpacity(0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Get.back();
              // // TODO: Implement cancel ride API call
              // _authController.cancelRide(_ride!.id, context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Yes, Cancel',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 15,
      left: 15,
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'booked':
        return 'Your Trip has been Booked';
      case 'paid':
        return 'Payment Confirmed';
      case 'completed':
        return 'Trip Completed Successfully';
      case 'cancelled':
        return 'Trip was Cancelled';
      case 'ongoing':
        return 'Trip is in Progress';
      case 'assigned':
        return 'Driver Assigned';
      default:
        return 'Status: ${status.capitalizeFirstInfo}';
    }
  }
}
