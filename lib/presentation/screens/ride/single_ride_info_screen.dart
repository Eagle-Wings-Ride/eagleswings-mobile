import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/models/book_rides_model.dart';
import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../controller/ride/ride_controller.dart';
import '../../../injection_container.dart' as di;

class SingleRideInfoScreen extends StatefulWidget {
  const SingleRideInfoScreen({super.key});

  @override
  State<SingleRideInfoScreen> createState() => _SingleRideInfoScreenState();
}

class _SingleRideInfoScreenState extends State<SingleRideInfoScreen> {
  final AuthController _authController = Get.find();
    final HomeController _homeController = Get.find();

  // Declare `ride` as nullable
  Booking? ride;

  @override
  void initState() {
    super.initState();
    // Retrieve the rideId from arguments
    final rideId = Get.arguments['rideId'];

    // Find the ride that matches the rideId
    setState(() {
      ride = _authController.recentRides.firstWhere(
        (r) => r.id == rideId,
        // orElse: () {
        //   return Booking(
        //     id: 'placeholder',
        //     pickUpLocation: 'Unknown',
        //     dropOffLocation: 'Unknown',
        //     status: 'Unknown',
        //   );
        //   ;
        // }, // Return null if no match is found
      );
    });
  }

  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(23.030357, 72.517845),
    zoom: 14.4746,
  );
  final RideController _uberMapController = Get.put(di.sl<RideController>());
  @override
  Widget build(BuildContext context) {
    if (ride == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ride Details')),
        body: const Center(child: Text('Ride not found')),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              Positioned.fill(
                child: GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_homeController.currentLat.value, _homeController.currentLng.value),
                    zoom: 14.4746,
                  ),
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  // trafficEnabled: true,
                  buildingsEnabled: true,
                  markers: _uberMapController.markers.value.toSet(),
                  polylines: {
                    Polyline(
                        polylineId: const PolylineId("polyLine"),
                        visible: true,
                        color: backgroundColor,
                        width: 6,
                        jointType: JointType.round,
                        startCap: Cap.roundCap,
                        endCap: Cap.roundCap,
                        geodesic: true,
                        points: _uberMapController.polylineCoordinates.value),
                    Polyline(
                        polylineId: const PolylineId("polyLineForAcptDriver"),
                        color: Colors.black,
                        width: 6,
                        jointType: JointType.round,
                        startCap: Cap.roundCap,
                        endCap: Cap.roundCap,
                        geodesic: true,
                        points: _uberMapController
                            .polylineCoordinatesforacptDriver.value),
                  },
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _uberMapController.controller.complete(controller);
                    // controller.setMapStyle('assets/map_style_black.json');
                    controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(ride!.latitude, ride!.longitude),
                          zoom: 14.4746,
                        ),
                      ),
                    );
                  },
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.6, // 40% of screen height
                minChildSize: 0.6, // Minimum drag size
                maxChildSize: 0.8, // Maximum drag size
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Stack(
                    children: [
                      Container(
                        // height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          // color: textColor,
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        // color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 40, horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    ride!.longitude.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: backgroundColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.phone_outlined,
                                          color: backgroundColor,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: backgroundColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.message_outlined,
                                          color: backgroundColor,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(8),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/account_icon.png'), // Replace with your image
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Driver Name
                                        Text(
                                          'Sergio Ramasis',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        // Distance and Time
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.location_on_outlined,
                                                size: 14,
                                                color: Colors.black),
                                            const SizedBox(width: 4),
                                            Text(
                                              '200m (4 mins away)',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        // Rating
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                size: 14, color: Colors.amber),
                                            const SizedBox(width: 4),
                                            Text(
                                              '4.0 (250 reviews)',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Right Content (License Plate and Car Name)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'FJK-254AG',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        constraints: const BoxConstraints(
                                          maxWidth:
                                              100, // Restrict the maximum width for car name
                                        ),
                                        child: Text(
                                          'Toyota Corolla',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.orangeAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 60.h,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '102 fox drive to Millennium Drive',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.h,
                                          vertical: 5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color.fromRGBO(
                                              255, 85, 0, .14),
                                        ),
                                        child: Text(
                                          'In-house Driver',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: const Color(0xffFF5500),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.h,
                                          vertical: 5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color.fromRGBO(
                                              19, 59, 183, .14),
                                        ),
                                        child: Text(
                                          'Return trip',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: const Color(0xff133BB7),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/arrow_location.png',
                                        width: 15,
                                        height: 15,
                                      ),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Text(
                                        'From: 102 Fox drive',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                    runAlignment: WrapAlignment.center,
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: Colors.black,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        'Pick Up time: 8:30am',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      const Icon(
                                        Icons.access_time,
                                        color: Colors.black,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        'Arrival time: 8:30am',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Positioned(
                top: 10,
                left: 0,
                child: GestureDetector(
                  onTap: Get.back,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 7,
                          // right: 2
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          // size: 20,
                          fill: 0.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
