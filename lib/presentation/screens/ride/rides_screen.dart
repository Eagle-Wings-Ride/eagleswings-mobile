import 'package:eaglerides/presentation/screens/ride/book_ride.dart';
import 'package:eaglerides/presentation/screens/ride/single_ride_info_screen.dart';
import 'package:eaglerides/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/utils/format_date.dart';
import '../../../core/utils/get_status.dart';
import '../../../data/models/book_rides_model.dart';
import '../../controller/auth/auth_controller.dart';
import '../account/child_registration.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  List<Booking> childrenList = []; // List of Child objects
  String? selectedChildId; // To store the selected child's ID
  String? selectedChildName; // To store the selected child's name
  bool isLoading = true;
  bool idSelected = false;
  final AuthController _authController = Get.find();
  List<Map<String, String>> ongoingRides = [
    {
      'title': 'Toronto to Alberta Trip',
      'time': '4 minutes',
      'driverName': 'Sergio',
      'rideType': 'In-House',
      'status': 'Upcoming',
    },
  ];
  List<Map<String, String>> recentRides = [
    {
      'title': 'New York to Boston Trip',
      'time': '12 minutes ago',
      'rideType': 'In-House',
      'status': 'Upcoming',
    },
    {
      'title': 'Toronto to Alberta Trip',
      'time': '34 minutes ago',
      'rideType': 'Freelance',
      'status': 'Completed',
    },
    {
      'title': 'Chicago to Detroit Trip',
      'time': '1 hour ago',
      'rideType': 'In-House',
      'status': 'In Progress',
    },
    {
      'title': 'Los Angeles to San Francisco Trip',
      'time': '2 hours ago',
      'rideType': 'Freelance',
      'status': 'Cancelled',
    },
    {
      'title': 'Miami to Orlando Trip',
      'time': '3 hours ago',
      'rideType': 'In-House',
      'status': 'Completed',
    },
    {
      'title': 'Houston to Austin Trip',
      'time': '5 hours ago',
      'rideType': 'Freelance',
      'status': 'Upcoming',
    },
    {
      'title': 'Seattle to Portland Trip',
      'time': '8 hours ago',
      'rideType': 'In-House',
      'status': 'In Progress',
    },
    {
      'title': 'Atlanta to Charlotte Trip',
      'time': '10 hours ago',
      'rideType': 'Freelance',
      'status': 'Completed',
    },
    {
      'title': 'Las Vegas to Phoenix Trip',
      'time': '1 day ago',
      'rideType': 'In-House',
      'status': 'Cancelled',
    },
    {
      'title': 'Denver to Salt Lake City Trip',
      'time': '2 days ago',
      'rideType': 'Freelance',
      'status': 'Upcoming',
    },
    {
      'title': 'San Diego to Tijuana Trip',
      'time': '3 days ago',
      'rideType': 'In-House',
      'status': 'Completed',
    },
    {
      'title': 'Philadelphia to New Jersey Trip',
      'time': '4 days ago',
      'rideType': 'Freelance',
      'status': 'In Progress',
    },
    {
      'title': 'Dallas to Fort Worth Trip',
      'time': '5 days ago',
      'rideType': 'In-House',
      'status': 'Cancelled',
    },
    {
      'title': 'Washington D.C. to Baltimore Trip',
      'time': '1 week ago',
      'rideType': 'Freelance',
      'status': 'Upcoming',
    },
    {
      'title': 'Boston to Providence Trip',
      'time': '2 weeks ago',
      'rideType': 'In-House',
      'status': 'Completed',
    },
    {
      'title': 'Nashville to Memphis Trip',
      'time': '3 weeks ago',
      'rideType': 'Freelance',
      'status': 'In Progress',
    },
    {
      'title': 'Indianapolis to Cincinnati Trip',
      'time': '4 weeks ago',
      'rideType': 'In-House',
      'status': 'Upcoming',
    },
    {
      'title': 'Kansas City to St. Louis Trip',
      'time': '1 month ago',
      'rideType': 'Freelance',
      'status': 'Cancelled',
    },
    {
      'title': 'Portland to Eugene Trip',
      'time': '1 month ago',
      'rideType': 'In-House',
      'status': 'Completed',
    },
    {
      'title': 'Detroit to Cleveland Trip',
      'time': '6 weeks ago',
      'rideType': 'Freelance',
      'status': 'In Progress',
    },
  ];

  @override
  void initState() {
    fetchChildrenData();
    super.initState();
  }

  Future<void> fetchChildrenData() async {
    try {
      await _authController.fetchChildren();

      setState(() {
        if (_authController.children.isNotEmpty) {
          selectedChildId = _authController.children.first.id;
          selectedChildName = _authController.children.first.fullname;
        } else {
          selectedChildId = null;
          selectedChildName = null;
        }
        isLoading = false;
      });
      await _authController.fetchRecentRides(selectedChildId!);
      setState(() {
        childrenList = _authController.recentRides;
      });
      // print('childrenList');
      // print(childrenList);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // print('Error fetching children: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 22.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_authController.children.isEmpty) {
                            // Redirect to create child page if no children are available
                            Get.to(
                                const ChildRegistration()); // Replace with your navigation route
                          } else {
                            showModalBottomSheet(
                              isDismissible: true,
                              showDragHandle: true,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              context: context,
                              builder: (BuildContext context) {
                                return FractionallySizedBox(
                                  heightFactor: calculateHeightFactor(
                                      _authController.children.length),
                                  child: Card(
                                    child: Container(
                                      // height: 350,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(19)),
                                      child: ListView(
                                        children: [
                                          Text(
                                            'Select Child',
                                            style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                color: textColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: _authController
                                                  .children.length,
                                              itemBuilder: (context, idx) {
                                                return Column(
                                                  children: [
                                                    ListTileTheme(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 13.0,
                                                              right: 13.0,
                                                              top: 4,
                                                              bottom: 4),
                                                      selectedColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                      child: ListTile(
                                                        title: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              child: Text(
                                                                _authController
                                                                    .children[
                                                                        idx]
                                                                    .fullname,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      textColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          setState(() {
                                                            // idSelected = true;
                                                            selectedChildId =
                                                                _authController
                                                                    .children[
                                                                        idx]
                                                                    .id;
                                                            selectedChildName =
                                                                _authController
                                                                    .children[
                                                                        idx]
                                                                    .fullname;
                                                          });
                                                          await _authController
                                                              .fetchRecentRides(
                                                                  _authController
                                                                      .children[
                                                                          idx]
                                                                      .id);

                                                          // _genderController.text =
                                                          //     childrenList[idx];
                                                          childrenList =
                                                              _authController
                                                                  .recentRides;
                                                          Navigator.pop(
                                                            context,
                                                          );

                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                    (idx !=
                                                            _authController
                                                                    .children
                                                                    .length -
                                                                1)
                                                        ? Divider(
                                                            color: greyColor,
                                                            height: 1,
                                                            indent: 13,
                                                            endIndent: 13,
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.profile_circle,
                              color: backgroundColor,
                              size: 16,
                            ),
                            selectedChildName != null
                                ? Text(
                                    selectedChildName!,
                                    style: GoogleFonts.poppins(
                                      color: backgroundColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          const ChildRegistration()); // Navigate to create child page
                                    },
                                    child: Text(
                                      ' No child available.',
                                      style: GoogleFonts.poppins(
                                        color: backgroundColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                              color: backgroundColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.notifications,
                          color: backgroundColor,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (selectedChildName != null)
                    Text(
                      'Hello $selectedChildName',
                      style: GoogleFonts.poppins(
                        color: backgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(
                    height: 30.h,
                  ),
                  // Column(
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 10.w),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text(
                  //             'Ongoing Rides',
                  //             style: GoogleFonts.poppins(
                  //               fontSize: 12,
                  //               fontWeight: FontWeight.bold,
                  //               color: textColor,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 13.h,
                  // ),
                  // Column(
                  //   children: ongoingRides.map((ongoing) {
                  //     return Column(
                  //       children: [
                  //         GestureDetector(
                  //           onTap: () {
                  //             // Get.to(SingleRideInfoScreen());
                  //           },
                  //           child: Container(
                  //             padding: EdgeInsets.symmetric(
                  //               horizontal: 10.w,
                  //               vertical: 5.h,
                  //             ),
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(15),
                  //               color: page,
                  //               boxShadow: const [
                  //                 BoxShadow(
                  //                   color: Color.fromRGBO(9, 39, 127, .15),
                  //                   blurRadius: 30.0,
                  //                   spreadRadius: -4.0,
                  //                 ),
                  //               ],
                  //             ),
                  //             child: Stack(
                  //               children: [
                  //                 Row(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceBetween,
                  //                   children: [
                  //                     Flexible(
                  //                       flex: 9,
                  //                       child: Row(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.center,
                  //                         children: [
                  //                           Flexible(
                  //                             flex: 2,
                  //                             child: ClipOval(
                  //                               child: Image.asset(
                  //                                 'assets/images/rides_img.jpg',
                  //                                 width: 45,
                  //                                 height: 45,
                  //                                 fit: BoxFit.fitWidth,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                           SizedBox(width: 15.w),
                  //                           Flexible(
                  //                             flex: 8,
                  //                             child: Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment
                  //                                       .spaceBetween,
                  //                               children: [
                  //                                 Text(
                  //                                   ongoing['title']!,
                  //                                   maxLines: 1,
                  //                                   overflow:
                  //                                       TextOverflow.ellipsis,
                  //                                   style: GoogleFonts.poppins(
                  //                                     fontSize: 14,
                  //                                     fontWeight:
                  //                                         FontWeight.bold,
                  //                                     color: textColor,
                  //                                   ),
                  //                                 ),
                  //                                 SizedBox(height: 8.h),
                  //                                 Row(
                  //                                   children: [
                  //                                     Container(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .symmetric(
                  //                                               horizontal: 5,
                  //                                               vertical: 3),
                  //                                       decoration:
                  //                                           BoxDecoration(
                  //                                         color: (ongoing[
                  //                                                     'rideType'] ==
                  //                                                 'In-House')
                  //                                             ? const Color
                  //                                                 .fromRGBO(255,
                  //                                                 85, 0, 0.14)
                  //                                             : const Color
                  //                                                 .fromRGBO(19,
                  //                                                 59, 183, .14),
                  //                                         borderRadius:
                  //                                             BorderRadius
                  //                                                 .circular(40),
                  //                                       ),
                  //                                       child: Text(
                  //                                         '${ongoing['rideType']} Driver',
                  //                                         style: GoogleFonts
                  //                                             .poppins(
                  //                                           color: (ongoing[
                  //                                                       'rideType'] ==
                  //                                                   'In-House')
                  //                                               ? backgroundColor
                  //                                               : const Color(
                  //                                                   0xff133BB7),
                  //                                           fontSize: 8,
                  //                                           fontWeight:
                  //                                               FontWeight.bold,
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                     SizedBox(width: 6.w),
                  //                                     Container(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .symmetric(
                  //                                               horizontal: 5,
                  //                                               vertical: 3),
                  //                                       decoration:
                  //                                           BoxDecoration(
                  //                                         color: getStatusColor(
                  //                                             ongoing[
                  //                                                 'status']),
                  //                                         borderRadius:
                  //                                             BorderRadius
                  //                                                 .circular(40),
                  //                                       ),
                  //                                       child: Text(
                  //                                         ongoing['status']!,
                  //                                         style: GoogleFonts
                  //                                             .poppins(
                  //                                           color: getStatusTextColor(
                  //                                               ongoing[
                  //                                                   'status']),
                  //                                           fontSize: 8,
                  //                                           fontWeight:
                  //                                               FontWeight.bold,
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                                 SizedBox(height: 8.h),
                  //                                 Text(
                  //                                   'Arrives in ${ongoing['time']}',
                  //                                   style: GoogleFonts.poppins(
                  //                                     fontSize: 12,
                  //                                     fontWeight:
                  //                                         FontWeight.w500,
                  //                                     color: textColor,
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                     const Flexible(
                  //                       flex: 2,
                  //                       child: Icon(
                  //                         Icons.more_horiz,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 // Add text at the bottom-right
                  //                 Positioned(
                  //                   bottom: 5, // Adjust based on spacing
                  //                   right:
                  //                       5, // Align to the bottom-right corner
                  //                   child: Row(
                  //                     children: [
                  //                       Image.asset(
                  //                         'assets/images/driver_ongoing_icon.png',
                  //                         width: 15,
                  //                         height: 15,
                  //                       ),
                  //                       const SizedBox(
                  //                         width: 5,
                  //                       ),
                  //                       Text(
                  //                         ongoing[
                  //                             'driverName']!, // Replace with dynamic text if needed
                  //                         style: GoogleFonts.poppins(
                  //                           fontSize: 12,
                  //                           fontWeight: FontWeight.bold,
                  //                           color:
                  //                               backgroundColor, // Style as desired
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(height: 12.h),
                  //       ],
                  //     );
                  //   }).toList(),
                  // ),

                  // SizedBox(
                  //   height: 20.h,
                  // ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Rides',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 13.h,
                  ),
                  _authController.children.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'No children found. Please create a child to view recent rides.',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width - 100,
                                      50),
                                  backgroundColor: backgroundColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      50,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  // Navigate to create child screen
                                  Get.to(const ChildRegistration());
                                },
                                child: Text(
                                  'Create Child',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: buttonText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : selectedChildId == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Please select a child to see recent rides.',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 20),
                                  DropdownButton<String>(
                                    value: selectedChildId,
                                    onChanged: (newChildId) {
                                      setState(() {
                                        selectedChildId = newChildId;
                                      });
                                      _authController
                                          .fetchRecentRides(newChildId!);
                                    },
                                    items: _authController.children
                                        .map(
                                            (child) => DropdownMenuItem<String>(
                                                  value: child.id,
                                                  child: Text(child.fullname),
                                                ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            )
                          : (childrenList.isEmpty)
                              ? Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Text(
                                        'No Recent activities yet',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: childrenList.length,
                                  itemBuilder: (context, index) {
                                    final ride = childrenList[index];
                                    // print('ride');
                                    // print(ride);
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(const SingleRideInfoScreen(),
                                                arguments: {'rideId': ride.id});
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 5.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: page,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                      9, 39, 127, .15),
                                                  blurRadius: 30.0,
                                                  spreadRadius: -4.0,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  flex: 9,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    // main
                                                    children: [
                                                      Flexible(
                                                        flex: 2,
                                                        child: ClipOval(
                                                          child: Image.asset(
                                                            'assets/images/rides_img.jpg',
                                                            width: 45,
                                                            height: 45,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 15.w),
                                                      Flexible(
                                                        flex: 8,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              '${ride.pickUpLocation} to ${ride.dropOffLocation}',
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    textColor,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 8.h,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          3),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: getRideTypeColor(ride
                                                                            .rideType)
                                                                        .withOpacity(
                                                                            0.14),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                  ),
                                                                  child: Text(
                                                                    ride.rideType
                                                                        .capitalizeFirst!,
                                                                    style: GoogleFonts.poppins(
                                                                        color: getRideTypeColor(ride
                                                                            .rideType),
                                                                        fontSize:
                                                                            8,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 6.w,
                                                                ),
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          3),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: getStatusColor(ride
                                                                            .status
                                                                            .toLowerCase())
                                                                        .withOpacity(
                                                                            0.15),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                  ),
                                                                  child: Text(
                                                                    ride.status,
                                                                    style: GoogleFonts.poppins(
                                                                        color: getStatusColor(ride
                                                                            .status
                                                                            .toLowerCase()),
                                                                        fontSize:
                                                                            8,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 8.h,
                                                            ),
                                                            Text(
                                                              formatDate(ride
                                                                  .createdAt),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    textColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // const Flexible(
                                                //   flex: 2,
                                                //   child: Icon(
                                                //     Icons.more_horiz,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                      ],
                                    );
                                  },
                                ),

                  // Column(
                  //   children: recentRides.map((recent) {
                  //     return Column(
                  //       children: [
                  //         Container(
                  //           padding: EdgeInsets.symmetric(
                  //               horizontal: 10.w, vertical: 5.h),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15),
                  //             color: page,
                  //             boxShadow: const [
                  //               BoxShadow(
                  //                 color: Color.fromRGBO(9, 39, 127, .15),
                  //                 blurRadius: 30.0,
                  //                 spreadRadius: -4.0,
                  //               ),
                  //             ],
                  //           ),
                  //           child: Stack(
                  //             children: [
                  //               Row(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Flexible(
                  //                     flex: 9,
                  //                     child: Row(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.center,
                  //                       children: [
                  //                         Flexible(
                  //                           flex: 2,
                  //                           child: ClipOval(
                  //                             child: Image.asset(
                  //                               'assets/images/rides_img.jpg',
                  //                               width: 45,
                  //                               height: 45,
                  //                               fit: BoxFit.fitWidth,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         SizedBox(width: 15.w),
                  //                         Flexible(
                  //                           flex: 8,
                  //                           child: Column(
                  //                             crossAxisAlignment:
                  //                                 CrossAxisAlignment.start,
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment.center,
                  //                             children: [
                  //                               Text(
                  //                                 recent['title']!,
                  //                                 maxLines: 1,
                  //                                 overflow:
                  //                                     TextOverflow.ellipsis,
                  //                                 style: GoogleFonts.poppins(
                  //                                   fontSize: 14,
                  //                                   fontWeight: FontWeight.bold,
                  //                                   color: textColor,
                  //                                 ),
                  //                               ),
                  //                               SizedBox(height: 8.h),
                  //                               Row(
                  //                                 children: [
                  //                                   Container(
                  //                                     padding: const EdgeInsets
                  //                                         .symmetric(
                  //                                         horizontal: 5,
                  //                                         vertical: 3),
                  //                                     decoration: BoxDecoration(
                  //                                       color:
                  //                                           (recent['rideType'] ==
                  //                                                   'In-House')
                  //                                               ? const Color
                  //                                                   .fromRGBO(
                  //                                                   255,
                  //                                                   85,
                  //                                                   0,
                  //                                                   0.14)
                  //                                               : const Color
                  //                                                   .fromRGBO(
                  //                                                   19,
                  //                                                   59,
                  //                                                   183,
                  //                                                   .14),
                  //                                       borderRadius:
                  //                                           BorderRadius
                  //                                               .circular(40),
                  //                                     ),
                  //                                     child: Text(
                  //                                       '${recent['rideType']} Driver',
                  //                                       style:
                  //                                           GoogleFonts.poppins(
                  //                                         color: (recent[
                  //                                                     'rideType'] ==
                  //                                                 'In-House')
                  //                                             ? backgroundColor
                  //                                             : const Color(
                  //                                                 0xff133BB7),
                  //                                         fontSize: 8,
                  //                                         fontWeight:
                  //                                             FontWeight.bold,
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                                   SizedBox(width: 6.w),
                  //                                   Container(
                  //                                     padding: const EdgeInsets
                  //                                         .symmetric(
                  //                                         horizontal: 5,
                  //                                         vertical: 3),
                  //                                     decoration: BoxDecoration(
                  //                                       color: getStatusColor(
                  //                                               recent['status']!
                  //                                                   .toLowerCase())
                  //                                           .withOpacity(0.14),
                  //                                       borderRadius:
                  //                                           BorderRadius
                  //                                               .circular(40),
                  //                                     ),
                  //                                     child: Text(
                  //                                       recent['status']!,
                  //                                       style:
                  //                                           GoogleFonts.poppins(
                  //                                         color: getStatusColor(
                  //                                             recent['status']!
                  //                                                 .toLowerCase()),
                  //                                         fontSize: 8,
                  //                                         fontWeight:
                  //                                             FontWeight.bold,
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                               SizedBox(height: 8.h),
                  //                               Text(
                  //                                 recent['time']!,
                  //                                 style: GoogleFonts.poppins(
                  //                                   fontSize: 12,
                  //                                   fontWeight: FontWeight.w500,
                  //                                   color: textColor,
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   const Flexible(
                  //                     flex: 2,
                  //                     child: Icon(
                  //                       Icons.more_horiz,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               // Add text at the bottom-right
                  //               Positioned(
                  //                 bottom: 5, // Adjust this value for spacing
                  //                 right: 5, // Align to the bottom-right corner
                  //                 child: Image.asset(
                  //                   'assets/images/recent_rides_icon.png',
                  //                   width: 25,
                  //                   height: 25,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         SizedBox(height: 12.h),
                  //       ],
                  //     );
                  //   }).toList(),
                  // ),

                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const BookRide());
        },
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.drive_eta),
      ),
    );
  }

  double calculateHeightFactor(int childrenCount) {
    // Minimum height factor is 0.6, increase by 0.1 for every 3 children
    double heightFactor = 0.6 + (childrenCount / 10);
    return heightFactor > 1.0 ? 1.0 : heightFactor; // Limit it to a max of 1.0
  }
}
