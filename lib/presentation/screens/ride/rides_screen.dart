import 'package:eaglerides/presentation/screens/ride/book_ride.dart';
import 'package:eaglerides/presentation/screens/ride/single_ride_info_screen.dart';
import 'package:eaglerides/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  Color getStatusColor(String? status) {
    switch (status) {
      case 'Completed':
        return const Color.fromRGBO(17, 205, 1, .15); // Light green
      case 'Upcoming':
        return const Color.fromARGB(33, 255, 81, 0); // Light orange
      case 'In Progress':
        return const Color.fromRGBO(0, 123, 255, .15); // Light blue
      case 'Cancelled':
        return const Color.fromRGBO(255, 0, 0, .15); // Light red
      default:
        return Colors.grey
            .withOpacity(0.15); // Default color for unknown statuses
    }
  }

  Color getStatusTextColor(String? status) {
    switch (status) {
      case 'Completed':
        return const Color(0xff11CD01); // Green
      case 'Upcoming':
        return const Color(0xffFF5500); // Orange
      case 'In Progress':
        return const Color(0xff007BFF); // Blue
      case 'Cancelled':
        return const Color(0xffFF0000); // Red
      default:
        return Colors.black; // Default text color
    }
  }

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
                      Row(
                        children: [
                          Icon(
                            Iconsax.profile_circle,
                            color: backgroundColor,
                            size: 16,
                          ),
                          Text(
                            'Timmy Spark',
                            style: GoogleFonts.poppins(
                                color: backgroundColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: backgroundColor,
                          ),
                        ],
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
                  Text(
                    'Hello Timmy',
                    style: GoogleFonts.poppins(
                      color: backgroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ongoing Rides',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            // Text(
                            //   'View all',
                            //   style: GoogleFonts.poppins(
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.w500,
                            //     color: textColor,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 13.h,
                  ),
                  Column(
                    children: ongoingRides.map((ongoing) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(SingleRideInfoScreen());
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: page,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(9, 39, 127, .15),
                                    blurRadius: 30.0,
                                    spreadRadius: -4.0,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 9,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: ClipOval(
                                                child: Image.asset(
                                                  'assets/images/rides_img.jpg',
                                                  width: 45,
                                                  height: 45,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 15.w),
                                            Flexible(
                                              flex: 8,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    ongoing['title']!,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 3),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: (ongoing[
                                                                      'rideType'] ==
                                                                  'In-House')
                                                              ? const Color
                                                                  .fromRGBO(255,
                                                                  85, 0, 0.14)
                                                              : const Color
                                                                  .fromRGBO(19,
                                                                  59, 183, .14),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(40),
                                                        ),
                                                        child: Text(
                                                          '${ongoing['rideType']} Driver',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: (ongoing[
                                                                        'rideType'] ==
                                                                    'In-House')
                                                                ? backgroundColor
                                                                : const Color(
                                                                    0xff133BB7),
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 6.w),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 3),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: getStatusColor(
                                                              ongoing[
                                                                  'status']),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(40),
                                                        ),
                                                        child: Text(
                                                          ongoing['status']!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: getStatusTextColor(
                                                                ongoing[
                                                                    'status']),
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Text(
                                                    'Arrives in ${ongoing['time']}',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Flexible(
                                        flex: 2,
                                        child: Icon(
                                          Icons.more_horiz,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Add text at the bottom-right
                                  Positioned(
                                    bottom: 5, // Adjust based on spacing
                                    right:
                                        5, // Align to the bottom-right corner
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/driver_ongoing_icon.png',
                                          width: 15,
                                          height: 15,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          ongoing[
                                              'driverName']!, // Replace with dynamic text if needed
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                backgroundColor, // Style as desired
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
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
                            // Text(
                            //   'View all',
                            //   style: GoogleFonts.poppins(
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.w500,
                            //     color: textColor,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 13.h,
                  ),
                  Column(
                    children: recentRides.map((recent) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: page,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(9, 39, 127, .15),
                                  blurRadius: 30.0,
                                  spreadRadius: -4.0,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 9,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: ClipOval(
                                              child: Image.asset(
                                                'assets/images/rides_img.jpg',
                                                width: 45,
                                                height: 45,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15.w),
                                          Flexible(
                                            flex: 8,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  recent['title']!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor,
                                                  ),
                                                ),
                                                SizedBox(height: 8.h),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 3),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            (recent['rideType'] ==
                                                                    'In-House')
                                                                ? const Color
                                                                    .fromRGBO(
                                                                    255,
                                                                    85,
                                                                    0,
                                                                    0.14)
                                                                : const Color
                                                                    .fromRGBO(
                                                                    19,
                                                                    59,
                                                                    183,
                                                                    .14),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                      ),
                                                      child: Text(
                                                        '${recent['rideType']} Driver',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: (recent[
                                                                      'rideType'] ==
                                                                  'In-House')
                                                              ? backgroundColor
                                                              : const Color(
                                                                  0xff133BB7),
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 6.w),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 3),
                                                      decoration: BoxDecoration(
                                                        color: getStatusColor(
                                                            recent['status']),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                      ),
                                                      child: Text(
                                                        recent['status']!,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color:
                                                              getStatusTextColor(
                                                                  recent[
                                                                      'status']),
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8.h),
                                                Text(
                                                  recent['time']!,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: textColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Flexible(
                                      flex: 2,
                                      child: Icon(
                                        Icons.more_horiz,
                                      ),
                                    ),
                                  ],
                                ),
                                // Add text at the bottom-right
                                Positioned(
                                  bottom: 5, // Adjust this value for spacing
                                  right: 5, // Align to the bottom-right corner
                                  child: Image.asset(
                                    'assets/images/recent_rides_icon.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                        ],
                      );
                    }).toList(),
                  ),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
