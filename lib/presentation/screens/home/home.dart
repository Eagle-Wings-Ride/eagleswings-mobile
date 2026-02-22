// import 'package:eaglerides/core/utils/format_date.dart';
// import 'package:eaglerides/data/models/book_rides_model.dart';
// import 'package:eaglerides/presentation/controller/auth/auth_controller.dart';
// import 'package:eaglerides/presentation/screens/ride/book_ride.dart';
// import 'package:eaglerides/presentation/screens/ride/widget/custom_loader.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../../core/utils/get_status.dart';
// import '../../../injection_container.dart' as di;
// import '../../../styles/styles.dart';
// import '../../controller/home/home_controller.dart';
// import '../account/child_registration.dart';
// import '../account/registered_children.dart';
// import '../ride/single_ride_info_screen.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with AutomaticKeepAliveClientMixin {
//   final HomeController _homeController = Get.put(di.sl<HomeController>());
//   final AuthController _authController = Get.find();

//   List<Booking> _recentRides = [];
//   String? _selectedChildId;
//   String? _selectedChildName;
//   bool _isLoadingChildren = true;
//   bool _isLoadingRides = false;
//   bool _hasRatesError = false;

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   /// Initialize all required data
//   Future<void> _initializeData() async {
//     // Run location fetch separately to avoid blocking
//     _homeController.getUserCurrentLocation().catchError((e) {
//       print('Error getting location: $e');
//     });

//     // Load children data
//     await _loadChildrenData();

//     // Load rates data (don't block on error)
//     _loadRatesData();
//   }

//   /// Load rates data with error handling
//   Future<void> _loadRatesData() async {
//     try {
//       await _authController.fetchRatesData();
//       setState(() => _hasRatesError = false);
//     } catch (e) {
//       print('Error fetching rates: $e');
//       setState(() => _hasRatesError = true);
//     }
//   }

//   /// Load children data and select first child by default
//   Future<void> _loadChildrenData() async {
//     try {
//       setState(() => _isLoadingChildren = true);

//       await _authController.fetchChildren();

//       // Safely check if children list is not empty
//       if (mounted && _authController.children.isNotEmpty) {
//         final firstChild = _authController.children.first;
//         setState(() {
//           _selectedChildId = firstChild.id;
//           _selectedChildName = firstChild.fullname;
//         });

//         // Load recent rides for the first child
//         await _loadRecentRides(_selectedChildId!);
//       } else {
//         setState(() {
//           _selectedChildId = null;
//           _selectedChildName = null;
//         });
//       }
//     } catch (e) {
//       _showErrorSnackbar('Failed to load children data');
//       print('Error fetching children: $e');
//     } finally {
//       if (mounted) {
//         setState(() => _isLoadingChildren = false);
//       }
//     }
//   }

//   /// Load recent rides for a specific child
//   Future<void> _loadRecentRides(String childId) async {
//     if (childId.isEmpty) return;

//     try {
//       setState(() => _isLoadingRides = true);

//       await _authController.fetchRecentRides(childId);

//       if (mounted) {
//         setState(() {
//           _recentRides = _authController.recentRides.toList();
//         });
//       }
//     } catch (e) {
//       _showErrorSnackbar('Failed to load recent rides');
//       print('Error fetching rides: $e');
//     } finally {
//       if (mounted) {
//         setState(() => _isLoadingRides = false);
//       }
//     }
//   }

//   /// Handle child selection change
//   Future<void> _onChildSelected(String childId, String childName) async {
//     if (childId.isEmpty) return;

//     setState(() {
//       _selectedChildId = childId;
//       _selectedChildName = childName;
//     });

//     await _loadRecentRides(childId);
//   }

//   /// Show error snackbar
//   void _showErrorSnackbar(String message) {
//     if (!mounted) return;

//     Get.snackbar(
//       'Error',
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red.withOpacity(0.8),
//       colorText: Colors.white,
//       duration: const Duration(seconds: 3),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     return Scaffold(
//       backgroundColor: const Color(0xffFEFEFF),
//       body: RefreshIndicator(
//         onRefresh: _initializeData,
//         color: backgroundColor,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Column(
//             children: [
//               _buildAppBar(context),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 33.h),
//                 child: Column(
//                   children: [
//                     _buildQuickActions(),
//                     SizedBox(height: 40.h),
//                     _buildRecentRidesSection(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Build quick action buttons
//   Widget _buildQuickActions() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildQuickButton(
//           image: 'check_rates',
//           text: 'Check rates',
//           onTap: _showRatesBottomSheet,
//         ),
//         _buildQuickButton(
//           image: 'book_rides',
//           text: 'Book rides',
//           onTap: () => Get.to(() => const BookRide()),
//         ),
//         _buildQuickButton(
//           image: 'track_rides',
//           text: 'Track rides',
//           onTap: () {
//             Get.snackbar('Coming Soon', 'Track rides feature');
//           },
//         ),
//         _buildQuickButton(
//           image: 'history',
//           text: 'Children',
//           onTap: () => Get.to(() => const RegisteredChildren()),
//         ),
//       ],
//     );
//   }

//   /// Build individual quick action button
//   Widget _buildQuickButton({
//     required String image,
//     required String text,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: backgroundColor,
//               borderRadius: BorderRadius.circular(100),
//               boxShadow: [
//                 BoxShadow(
//                   color: backgroundColor.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Image.asset(
//               'assets/images/$image.png',
//               width: 35,
//               height: 35,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             text,
//             style: GoogleFonts.poppins(
//               fontSize: 12,
//               color: textColor,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build recent rides section
//   /// Build recent rides section
//   Widget _buildRecentRidesSection() {
//     // Don't use Obx here since we're using setState for state management
//     if (_isLoadingChildren) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(40.0),
//           child: CustomLoader(),
//         ),
//       );
//     }

//     // Use a simple check on the children list
//     if (_authController.children.isEmpty) {
//       return _buildEmptyChildrenState();
//     }

//     if (_selectedChildId == null) {
//       return _buildNoChildSelectedState();
//     }

//     return Column(
//       children: [
//         _buildSectionHeader(),
//         const SizedBox(height: 15),
//         _isLoadingRides
//             ? const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(40.0),
//                   child: CustomLoader(),
//                 ),
//               )
//             : _recentRides.isEmpty
//                 ? _buildEmptyRidesState()
//                 : _buildRidesList(),
//       ],
//     );
//   }

//   /// Build section header
//   Widget _buildSectionHeader() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Ride History',
//             style: GoogleFonts.poppins(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: textColor,
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               Get.snackbar('Coming Soon', 'View all rides');
//             },
//             child: Text(
//               'See all',
//               style: GoogleFonts.poppins(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: backgroundColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build empty children state
//   Widget _buildEmptyChildrenState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(40.0),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(30),
//               decoration: BoxDecoration(
//                 color: backgroundColor.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Iconsax.profile_2user,
//                 size: 60,
//                 color: backgroundColor,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'No Children Found',
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: textColor,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Create a child profile to start booking rides',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 color: textColor.withOpacity(0.6),
//               ),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(MediaQuery.of(context).size.width - 100, 50),
//                 backgroundColor: backgroundColor,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//               ),
//               onPressed: () => Get.to(() => const ChildRegistration()),
//               icon: const Icon(Icons.add, color: Colors.white),
//               label: Text(
//                 'Create Child Profile',
//                 style: GoogleFonts.poppins(
//                   color: buttonText,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Build no child selected state
//   Widget _buildNoChildSelectedState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(40.0),
//         child: Column(
//           children: [
//             Icon(
//               Iconsax.user,
//               size: 60,
//               color: backgroundColor.withOpacity(0.5),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Please select a child',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: textColor,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Select a child from the dropdown above to view recent rides',
//               textAlign: TextAlign.center,
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

//   /// Build empty rides state
//   Widget _buildEmptyRidesState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(40.0),
//         child: Column(
//           children: [
//             Icon(
//               Iconsax.car,
//               size: 60,
//               color: backgroundColor.withOpacity(0.5),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'No Recent Rides',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: textColor,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'No ride history available for this child yet',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 color: textColor.withOpacity(0.6),
//               ),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: backgroundColor,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 15,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               onPressed: () => Get.to(() => const BookRide()),
//               icon: const Icon(Icons.add, color: Colors.white),
//               label: Text(
//                 'Book a Ride',
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Build rides list
//   Widget _buildRidesList() {
//     return ListView.builder(
//       padding: EdgeInsets.zero,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: _recentRides.length > 5 ? 5 : _recentRides.length,
//       itemBuilder: (context, index) {
//         final ride = _recentRides[index];
//         return _buildRideCard(ride);
//       },
//     );
//   }

//   /// Build individual ride card
//   Widget _buildRideCard(Booking ride) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12.h),
//       child: GestureDetector(
//         onTap: () {
//           Get.to(
//             () => const SingleRideInfoScreen(),
//             arguments: {'rideId': ride.id},
//           );
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             color: page,
//             boxShadow: const [
//               BoxShadow(
//                 color: Color.fromRGBO(9, 39, 127, .08),
//                 blurRadius: 20.0,
//                 spreadRadius: -2.0,
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.asset(
//                   'assets/images/rides_img.jpg',
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(width: 15.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${ride.pickUpLocation} → ${ride.dropOffLocation}',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: textColor,
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//                     Row(
//                       children: [
//                         _buildBadge(
//                           label: ride.rideType.capitalizeFirst!,
//                           color: getRideTypeColor(ride.rideType),
//                         ),
//                         SizedBox(width: 6.w),
//                         _buildBadge(
//                           label: ride.status.capitalizeFirst!,
//                           color: getStatusColor(ride.status.toLowerCase()),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8.h),
//                     Row(
//                       children: [
//                         Icon(
//                           Iconsax.clock,
//                           size: 12,
//                           color: textColor.withOpacity(0.6),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           formatDate(ride.createdAt),
//                           style: GoogleFonts.poppins(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w500,
//                             color: textColor.withOpacity(0.6),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.chevron_right,
//                 color: textColor.withOpacity(0.3),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Build status/type badge
//   Widget _buildBadge({required String label, required Color color}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         label,
//         style: GoogleFonts.poppins(
//           color: color,
//           fontSize: 10,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   /// Show rates bottom sheet
//   /// Show rates bottom sheet
//   void _showRatesBottomSheet() {
//     showModalBottomSheet(
//       isDismissible: true,
//       showDragHandle: true,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return FractionallySizedBox(
//           heightFactor: 0.6,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Trip Rates',
//                   style: GoogleFonts.poppins(
//                     fontSize: 20,
//                     color: textColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: Obx(() {
//                     // Check if rates are loading or have error
//                     if (_hasRatesError || _authController.rates.value == null) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.info_outline,
//                               size: 60,
//                               color: backgroundColor.withOpacity(0.5),
//                             ),
//                             const SizedBox(height: 20),
//                             Text(
//                               'Rates Not Available',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 color: textColor,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 20),
//                               child: Text(
//                                 'Unable to fetch rate information at this time.\nPlease try again later.',
//                                 textAlign: TextAlign.center,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 14,
//                                   color: textColor.withOpacity(0.6),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             ElevatedButton.icon(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                                 _loadRatesData();
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: backgroundColor,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 12,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),
//                               icon: const Icon(Icons.refresh,
//                                   color: Colors.white),
//                               label: Text(
//                                 'Retry',
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     return ListView.builder(
//                       itemCount: 2,
//                       itemBuilder: (context, idx) {
//                         String driverType =
//                             idx == 0 ? 'in_house_drivers' : 'freelance_drivers';
//                         return _buildRateCard(driverType);
//                       },
//                     );
//                   }),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   /// Build rate card
//   Widget _buildRateCard(String driverType) {
//     final rates = _authController.rates.value?[driverType];
//     final driverName =
//         driverType == 'in_house_drivers' ? 'In-House' : 'Freelance';

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: backgroundColor.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: backgroundColor.withOpacity(0.2),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$driverName Drivers',
//             style: GoogleFonts.poppins(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: textColor,
//             ),
//           ),
//           const SizedBox(height: 12),
//           // Use Wrap instead of Row to prevent overflow
//           Wrap(
//             spacing: 20,
//             runSpacing: 10,
//             children: [
//               _buildRateItem('One Way', rates?['one_way']),
//               _buildRateItem('Return', rates?['return']),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build rate item
//   Widget _buildRateItem(String label, dynamic value) {
//     return SizedBox(
//       width: 120, // Fixed width to prevent overflow
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.poppins(
//               fontSize: 12,
//               color: textColor.withOpacity(0.6),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             '\$${value ?? 'N/A'}',
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: backgroundColor,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build app bar
//   Widget _buildAppBar(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(20.0),
//           bottomRight: Radius.circular(20.0),
//         ),
//         color: backgroundColor,
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             bottom: 0,
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 22.w),
//               decoration: const BoxDecoration(
//                 color: Color.fromRGBO(148, 163, 208, 0.2),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20.0),
//                   bottomRight: Radius.circular(20.0),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'My Location',
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Obx(() => Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: const Color.fromRGBO(148, 163, 208, 0.3),
//                               borderRadius: BorderRadius.circular(40),
//                             ),
//                             child: const Icon(
//                               Icons.location_on_outlined,
//                               color: Colors.white,
//                               size: 14,
//                             ),
//                           ),
//                           SizedBox(width: 8.w),
//                           Expanded(
//                             child: Text(
//                               _homeController.address.value.isNotEmpty
//                                   ? _homeController.address.value
//                                   : 'Fetching address...',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 12,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       )),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 22.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 25.h),
//                 Image.asset(
//                   'assets/images/app_name_white.png',
//                   height: 14.h,
//                   width: 52.w,
//                 ),
//                 SizedBox(height: 25.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildChildSelector(),
//                     _buildNotificationButton(),
//                   ],
//                 ),
//                 SizedBox(height: 30.h),
//                 Text(
//                   'Ready for a Safe Ride?',
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 GestureDetector(
//                   onTap: () => Get.to(() => const BookRide()),
//                   child: Row(
//                     children: [
//                       Text(
//                         'Let\'s book a ride for your child',
//                         style: GoogleFonts.poppins(
//                           color: Colors.white.withOpacity(0.9),
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       Icon(
//                         Icons.arrow_forward,
//                         color: Colors.white.withOpacity(0.9),
//                         size: 18,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 70.h),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build child selector
//   /// Build child selector
//   Widget _buildChildSelector() {
//     return GestureDetector(
//       onTap: () {
//         if (_authController.children.isEmpty) {
//           Get.to(() => const ChildRegistration());
//         } else {
//           _showChildSelectorBottomSheet();
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: const Color.fromRGBO(148, 163, 208, 0.25),
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(
//               Iconsax.profile_circle,
//               color: Colors.white,
//               size: 18,
//             ),
//             const SizedBox(width: 8),
//             // Only wrap the changing text in Obx
//             Obx(() => Text(
//                   _selectedChildName != null
//                       ? 'Hello $_selectedChildName'
//                       : _authController.children.isEmpty
//                           ? 'Add Child'
//                           : 'Select Child',
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 )),
//             const SizedBox(width: 4),
//             const Icon(
//               Icons.keyboard_arrow_down,
//               size: 18,
//               color: Colors.white,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Build notification button
//   Widget _buildNotificationButton() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(148, 163, 208, 0.25),
//         borderRadius: BorderRadius.circular(40),
//       ),
//       child: const Icon(
//         Icons.notifications_none_outlined,
//         color: Colors.white,
//         size: 22,
//       ),
//     );
//   }

//   /// Show child selector bottom sheet
//   void _showChildSelectorBottomSheet() {
//     showModalBottomSheet(
//       isDismissible: true,
//       showDragHandle: true,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       context: context,
//       builder: (BuildContext context) {
//         return FractionallySizedBox(
//           heightFactor: _calculateHeightFactor(_authController.children.length),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Select Child',
//                   style: GoogleFonts.poppins(
//                     fontSize: 20,
//                     color: textColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _authController.children.length,
//                     itemBuilder: (context, idx) {
//                       final child = _authController.children[idx];
//                       final isSelected = _selectedChildId == child.id;

//                       return Column(
//                         children: [
//                           ListTile(
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             leading: Container(
//                               width: 45,
//                               height: 45,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: backgroundColor.withOpacity(0.1),
//                                 border: Border.all(
//                                   color: isSelected
//                                       ? backgroundColor
//                                       : Colors.transparent,
//                                   width: 2,
//                                 ),
//                               ),
//                               child: child.image != null
//                                   ? ClipOval(
//                                       child: Image.network(
//                                         child.image!,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (context, error,
//                                                 stackTrace) =>
//                                             _buildChildAvatar(child.fullname),
//                                       ),
//                                     )
//                                   : _buildChildAvatar(child.fullname),
//                             ),
//                             title: Text(
//                               child.fullname,
//                               style: GoogleFonts.poppins(
//                                 fontSize: 15,
//                                 fontWeight: isSelected
//                                     ? FontWeight.w600
//                                     : FontWeight.w500,
//                                 color: textColor,
//                               ),
//                             ),
//                             subtitle: Text(
//                               '${child.relationship} • Grade ${child.grade}',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 12,
//                                 color: textColor.withOpacity(0.6),
//                               ),
//                             ),
//                             trailing: isSelected
//                                 ? Icon(
//                                     Icons.check_circle,
//                                     color: backgroundColor,
//                                   )
//                                 : null,
//                             onTap: () async {
//                               Navigator.pop(context);
//                               await _onChildSelected(child.id, child.fullname);
//                             },
//                           ),
//                           if (idx != _authController.children.length - 1)
//                             Divider(
//                               color: greyColor,
//                               height: 1,
//                               indent: 70,
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   /// Build child avatar
//   Widget _buildChildAvatar(String name) {
//     return Center(
//       child: Text(
//         name.isNotEmpty ? name[0].toUpperCase() : '?',
//         style: GoogleFonts.poppins(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: backgroundColor,
//         ),
//       ),
//     );
//   }

//   /// Calculate bottom sheet height
//   double _calculateHeightFactor(int childrenCount) {
//     double heightFactor = 0.5 + (childrenCount * 0.05);
//     return heightFactor > 0.9 ? 0.9 : heightFactor;
//   }
// }

import 'package:eaglerides/presentation/screens/ride/rides_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/utils/format_date.dart';
import '../../../core/utils/get_status.dart';
import '../../../core/utils/state_persistence.dart';
import '../../../data/models/book_rides_model.dart';
import '../../../injection_container.dart' as di;
import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';
import '../../controller/home/home_controller.dart';
import '../account/child_registration.dart';
import '../account/registered_children.dart';
import '../ride/book_ride.dart';
import '../ride/single_ride_info_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final HomeController _homeController = Get.put(di.sl<HomeController>());
  final AuthController _authController = Get.find();

  List<Booking> _recentRides = [];
  String? _selectedChildId;
  String? _selectedChildName;
  bool _isLoadingChildren = true;
  bool _isLoadingRides = false;
  bool _hasRatesError = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    _homeController.getUserCurrentLocation().catchError((e) {
      print('Error getting location: $e');
    });

    await _loadChildrenData();
    _loadRatesData();
  }

  Future<void> _loadRatesData() async {
    try {
      await _authController.fetchRatesData();
      setState(() => _hasRatesError = false);
    } catch (e) {
      print('Error fetching rates: $e');
      setState(() => _hasRatesError = true);
    }
  }

  Future<void> _loadChildrenData() async {
    try {
      setState(() => _isLoadingChildren = true);

      await _authController.fetchChildren();

      if (mounted && _authController.children.isNotEmpty) {
        final firstChild = _authController.children.first;
        setState(() {
          _selectedChildId = firstChild.id;
          _selectedChildName = firstChild.fullname;
        });

        final savedChildId = StatePersistence.getSavedChildId();
        if (savedChildId != null) {
          setState(() {
            _selectedChildId = savedChildId;
            _selectedChildName = StatePersistence.getSavedChildName();
          });
          await _loadRecentRides(savedChildId);
        }

        await _loadRecentRides(_selectedChildId!);
      } else {
        setState(() {
          _selectedChildId = null;
          _selectedChildName = null;
        });
      }
    } catch (e) {
      _showErrorSnackbar('Failed to load children data');
      print('Error fetching children: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingChildren = false);
      }
    }
  }

  Future<void> _loadRecentRides(String childId) async {
    if (childId.isEmpty) return;

    try {
      setState(() => _isLoadingRides = true);

      await _authController.fetchRecentRides(childId);

      if (mounted) {
        setState(() {
          _recentRides = _authController.recentRides.toList();
        });
      }
    } catch (e) {
      _showErrorSnackbar('Failed to load recent rides');
      print('Error fetching rides: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingRides = false);
      }
    }
  }

  Future<void> _onChildSelected(String childId, String childName) async {
    if (childId.isEmpty) return;

    setState(() {
      _selectedChildId = childId;
      _selectedChildName = childName;
    });

    await StatePersistence.saveSelectedChild(
      childId: childId,
      childName: childName,
    );

    await _loadRecentRides(childId);
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;

    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xffFEFEFF),
      body: RefreshIndicator(
        onRefresh: _initializeData,
        color: backgroundColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildAppBar(context),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 25.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickActions(),
                    SizedBox(height: 35.h),
                    _buildRecentRidesSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        // SizedBox(height: 15.h),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 5.h,
          crossAxisSpacing: 15.w,
          childAspectRatio: 0.85,
          children: [
            _buildQuickButton(
              icon: Iconsax.money_4,
              text: 'Rates',
              onTap: _showRatesBottomSheet,
              color: Colors.green,
            ),
            _buildQuickButton(
              icon: Iconsax.car,
              text: 'Book',
              onTap: () => Get.to(() => const BookRide()),
              color: backgroundColor,
            ),
            _buildQuickButton(
              icon: Iconsax.location,
              text: 'Track',
              onTap: () {
                Get.snackbar('Coming Soon', 'Track rides feature');
              },
              color: Colors.blue,
            ),
            _buildQuickButton(
              icon: Iconsax.profile_2user,
              text: 'Children',
              onTap: () => Get.to(() => const RegisteredChildren()),
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRidesSection() {
    if (_isLoadingChildren) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_authController.children.isEmpty) {
      return _buildEmptyChildrenState();
    }

    if (_selectedChildId == null) {
      return _buildNoChildSelectedState();
    }

    return Column(
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 15),
        _isLoadingRides
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              )
            : _recentRides.isEmpty
                ? _buildEmptyRidesState()
                : _buildRidesList(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Rides',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        TextButton(
          onPressed: () => Get.to(() => const RidesScreen()),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'See all',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: backgroundColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: backgroundColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyChildrenState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.profile_2user,
                size: 60,
                color: backgroundColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Children Found',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Create a child profile to start booking rides',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width - 100, 50),
                backgroundColor: backgroundColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () => Get.to(() => const ChildRegistration()),
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'Create Child Profile',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoChildSelectedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(
              Iconsax.user,
              size: 60,
              color: backgroundColor.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            Text(
              'Please select a child',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Select a child from the header to view recent rides',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRidesState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(
              Iconsax.car,
              size: 60,
              color: backgroundColor.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            Text(
              'No Recent Rides',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'No ride history available for this child yet',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () => Get.to(() => const BookRide()),
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'Book a Ride',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRidesList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentRides.length > 5 ? 5 : _recentRides.length,
      itemBuilder: (context, index) {
        return _buildEnhancedRideCard(_recentRides[index]);
      },
    );
  }

  Widget _buildEnhancedRideCard(Booking ride) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => const SingleRideInfoScreen(),
            arguments: {'rideId': ride.id},
          );
        },
        child: Container(
          padding: EdgeInsets.all(14.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(ride.status.toLowerCase())
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      ride.status.capitalizeFirst!,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: getStatusColor(ride.status.toLowerCase()),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Iconsax.clock,
                        size: 12,
                        color: textColor.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatDate(ride.createdAt.toString()),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Route
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.radio_button_checked,
                          color: Colors.green,
                          size: 10,
                        ),
                      ),
                      ...List.generate(
                        3,
                        (index) => Container(
                          width: 2,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 1),
                          color: Colors.grey[300],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 10,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ride.mainPickupAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          ride.mainDropoffAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: textColor.withOpacity(0.3),
                    size: 20,
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Footer badges
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _buildSmallBadge(
                    label:
                        ride.rideType == 'inhouse' ? 'In-House' : 'Freelance',
                    color: getRideTypeColor(ride.rideType),
                    icon: Iconsax.user,
                  ),
                  _buildSmallBadge(
                    label: ride.isReturnTrip ? 'Return' : 'One Way',
                    color: const Color(0xff133BB7),
                    icon: Iconsax.repeat,
                  ),
                  if (ride.hasDrivers)
                    _buildSmallBadge(
                      label: 'Driver Assigned',
                      color: Colors.green,
                      icon: Iconsax.tick_circle,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallBadge({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showRatesBottomSheet() {
    showModalBottomSheet(
      isDismissible: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.65,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Rates',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Obx(() {
                    if (_hasRatesError || _authController.rates.value == null) {
                      return _buildRatesErrorState();
                    }

                    return ListView(
                      children: [
                        _buildRateCard('in_house_drivers', 'In-House Drivers'),
                        const SizedBox(height: 16),
                        _buildRateCard(
                            'freelance_drivers', 'Freelance Drivers'),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatesErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 60,
            color: backgroundColor.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'Rates Not Available',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Unable to fetch rate information at this time.\nPlease try again later.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _loadRatesData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: Text(
              'Retry',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateCard(String driverType, String driverName) {
    final rates = _authController.rates.value?[driverType];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: backgroundColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            driverName,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          // Daily rates
          _buildScheduleRateRow('Daily', rates?['daily']),
          const SizedBox(height: 10),
          // Bi-weekly rates
          _buildScheduleRateRow('2 Weeks', rates?['bi_weekly']),
          const SizedBox(height: 10),
          // Monthly rates
          _buildScheduleRateRow('Monthly', rates?['monthly']),
        ],
      ),
    );
  }

  Widget _buildScheduleRateRow(String scheduleLabel, dynamic scheduleRates) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          scheduleLabel,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildRateItem('One Way', scheduleRates?['one_way']),
            ),
            Expanded(
              child: _buildRateItem('Return', scheduleRates?['return']),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRateItem(String label, dynamic value) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: textColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${value ?? 'N/A'}',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: backgroundColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
        color: backgroundColor,
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 22.w),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(148, 163, 208, 0.2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Location',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Obx(() => Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(148, 163, 208, 0.3),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              _homeController.address.value.isNotEmpty
                                  ? _homeController.address.value
                                  : 'Fetching address...',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25.h),
                Image.asset(
                  'assets/images/app_name_white.png',
                  height: 14.h,
                  width: 52.w,
                ),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildChildSelector(),
                    _buildNotificationButton(),
                  ],
                ),
                SizedBox(height: 25.h),
                Text(
                  'Ready for a Safe Ride?',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () => Get.to(() => const BookRide()),
                  child: Row(
                    children: [
                      Text(
                        'Let\'s book a ride for your child',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white.withOpacity(0.9),
                        size: 18,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 65.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildSelector() {
    return GestureDetector(
      onTap: () {
        if (_authController.children.isEmpty) {
          Get.to(() => const ChildRegistration());
        } else {
          _showChildSelectorBottomSheet();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(148, 163, 208, 0.25),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Iconsax.profile_circle,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Obx(() => Text(
                  _selectedChildName != null
                      ? 'Hello $_selectedChildName'
                      : _authController.children.isEmpty
                          ? 'Add Child'
                          : 'Select Child',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(148, 163, 208, 0.25),
        borderRadius: BorderRadius.circular(40),
      ),
      child: const Icon(
        Icons.notifications_none_outlined,
        color: Colors.white,
        size: 22,
      ),
    );
  }

  void _showChildSelectorBottomSheet() {
    showModalBottomSheet(
      isDismissible: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: _calculateHeightFactor(_authController.children.length),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Child',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _authController.children.length,
                    itemBuilder: (context, idx) {
                      final child = _authController.children[idx];
                      final isSelected = _selectedChildId == child.id;

                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            leading: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: backgroundColor.withOpacity(0.1),
                                border: Border.all(
                                  color: isSelected
                                      ? backgroundColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: child.image != null
                                  ? ClipOval(
                                      child: Image.network(
                                        child.image!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            _buildChildAvatar(child.fullname),
                                      ),
                                    )
                                  : _buildChildAvatar(child.fullname),
                            ),
                            title: Text(
                              child.fullname,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                            subtitle: Text(
                              '${child.relationship} • Grade ${child.grade}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: textColor.withOpacity(0.6),
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    color: backgroundColor,
                                  )
                                : null,
                            onTap: () async {
                              Navigator.pop(context);
                              await _onChildSelected(child.id, child.fullname);
                            },
                          ),
                          if (idx != _authController.children.length - 1)
                            Divider(
                              color: greyColor,
                              height: 1,
                              indent: 70,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChildAvatar(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: backgroundColor,
        ),
      ),
    );
  }

  double _calculateHeightFactor(int childrenCount) {
    double heightFactor = 0.5 + (childrenCount * 0.05);
    return heightFactor > 0.9 ? 0.9 : heightFactor;
  }
}
