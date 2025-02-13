import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/utils/get_status.dart';
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
  final Completer<GoogleMapController> _controller = Completer();
  final AuthController _authController = Get.find();
  final HomeController _homeController = Get.find();
  BitmapDescriptor? _pickupIcon;
  BitmapDescriptor? _dropOffIcon;
  // Declare `ride` as nullable
  Booking? ride;

  @override
  void initState() {
    super.initState();
    _loadCustomMarkers();
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

  // Load the map style from assets
  // Future<String> _loadMapStyle() async {
  //   return await DefaultAssetBundle.of(context)
  //       .loadString('assets/map_style.json'); // Load your map style JSON file
  // }

  Future<void> _loadCustomMarkers() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/pickupmarker.png', 85);
    final Uint8List dropOffMarkerIcon =
        await getBytesFromAsset('assets/images/dropmarker.png', 85);
    setState(() {
      _pickupIcon = BitmapDescriptor.fromBytes(markerIcon);
      _dropOffIcon = BitmapDescriptor.fromBytes(dropOffMarkerIcon);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
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

  // static const CameraPosition _defaultLocation = CameraPosition(
  //   target: LatLng(23.030357, 72.517845),
  //   zoom: 14.4746,
  // );
  // final RideController _uberMapController = Get.put(di.sl<RideController>());
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
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              bottom: MediaQuery.of(context).size.height / 3,
              child: GoogleMap(
                mapType: MapType.terrain,
                initialCameraPosition: CameraPosition(
                  target: LatLng(ride!.endLatitude, ride!.endLongitude),
                  zoom: 17.4746,
                ),
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                compassEnabled: false,
                // trafficEnabled: true,
                buildingsEnabled: true,
                markers: {
                  if (_pickupIcon != null)
                    Marker(
                      markerId: const MarkerId("pickup"),
                      position: LatLng(
                        ride!.startLatitude,
                        ride!.startLongitude,
                      ),
                      // infoWindow: const InfoWindow(title: "Pickup Location"),
                      infoWindow: InfoWindow(
                        title: ride!.pickUpLocation,
                        snippet: "This is the pickup location",
                      ),

                      icon: _pickupIcon!,
                    ),
                  if (_dropOffIcon != null)
                    Marker(
                      // draggable: true,
                      markerId: const MarkerId("dropoff"),
                      position: LatLng(
                        ride!.endLatitude,
                        ride!.endLongitude,
                      ),
                      infoWindow: InfoWindow(
                        title: ride!.dropOffLocation,
                        snippet: "This is the dropoff location",
                      ),
                      icon: _dropOffIcon!,
                    ),
                },
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
                    points: [
                      LatLng(ride!.startLatitude, ride!.startLongitude),
                      LatLng(ride!.endLatitude, ride!.endLongitude)
                    ], // Ensure both pickup and drop-off are included
                  ),
                },
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                onMapCreated: (GoogleMapController controller) async {
                  // controller.setMapStyle(mapStyle);
                  // GoogleMap.style();
                  // _controller.future.then((value) {
                  //   value.setMapStyle(mapStyle);
                  // });
                  // controller.setMapStyle(mapStyle);
                  // controller.GoogleMap.style('assets/map_style.json');
                  controller.showMarkerInfoWindow(const MarkerId('pickup'));
                  _controller.complete(controller);

                  LatLng pickupLocation =
                      LatLng(ride!.startLatitude, ride!.startLongitude);

                  LatLng dropOffLocation =
                      LatLng(ride!.endLatitude, ride!.endLongitude);

                  // ✅ Ensure bounds are set correctly
                  LatLngBounds bounds = LatLngBounds(
                    southwest: LatLng(
                      min(pickupLocation.latitude, dropOffLocation.latitude),
                      min(pickupLocation.longitude, dropOffLocation.longitude),
                    ),
                    northeast: LatLng(
                      max(pickupLocation.latitude, dropOffLocation.latitude),
                      max(pickupLocation.longitude, dropOffLocation.longitude),
                    ),
                  );

                  final GoogleMapController mapController =
                      await _controller.future;

                  // ✅ Ensure map actually moves and fits both locations correctly
                  Future.delayed(const Duration(milliseconds: 300), () {
                    mapController.animateCamera(
                      CameraUpdate.newLatLngBounds(
                          bounds, 100), // Adjust padding if needed
                    );
                  });
                },
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.5, // 60% of the screen height when expanded
              minChildSize: 0.4, // Minimum height when collapsed
              maxChildSize: 0.8, // Maximum drag size
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
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
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                (ride!.status == 'booked')
                                    ? 'Your Trip has been Booked'
                                    : (ride!.status == 'completed')
                                        ? 'Trip Completed'
                                        : (ride!.status == 'cancelled')
                                            ? 'Trip Cancelled'
                                            : (ride!.status == 'ongoing')
                                                ? 'Your Trip is in progress'
                                                : 'Status will be updated soon ...',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // Row(
                              //   children: [
                              //     Container(
                              //       padding: const EdgeInsets.all(6),
                              //       decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         border: Border.all(
                              //           color: backgroundColor,
                              //           width: 1,
                              //         ),
                              //       ),
                              //       child: Icon(
                              //         Icons.phone_outlined,
                              //         color: backgroundColor,
                              //         size: 20,
                              //       ),
                              //     ),
                              //     const SizedBox(
                              //       width: 10,
                              //     ),
                              //     Container(
                              //       padding: const EdgeInsets.all(6),
                              //       decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         border: Border.all(
                              //           color: backgroundColor,
                              //           width: 1,
                              //         ),
                              //       ),
                              //       child: Icon(
                              //         Icons.message_outlined,
                              //         color: backgroundColor,
                              //         size: 20,
                              //       ),
                              //     ),
                              //   ],
                              // ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        const Icon(Icons.location_on_outlined,
                                            size: 14, color: Colors.black),
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
                            height: 40.h,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(23),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(
                                      0.5), // Shadow color with opacity
                                  spreadRadius:
                                      2, // How wide the shadow spreads
                                  blurRadius: 5, // The softness of the shadow
                                  offset: const Offset(3,
                                      3), // Position of shadow: x, y (right, down)
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${ride!.pickUpLocation} To ${ride!.dropOffLocation}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // Row(
                                //   children: [
                                //     Container(
                                //       padding: EdgeInsets.symmetric(
                                //         horizontal: 8.h,
                                //         vertical: 5.h,
                                //       ),
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(15),
                                //         color: getRideTypeColor(ride!.rideType)
                                //             .withOpacity(0.14),
                                //       ),
                                //       child: Text(
                                //         (ride!.rideType == 'inhouse')
                                //             ? 'In-house driver'
                                //             : 'Freelance Driver',
                                //         style: GoogleFonts.poppins(
                                //           fontSize: 10,
                                //           color:
                                //               getRideTypeColor(ride!.rideType),
                                //           fontWeight: FontWeight.bold,
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       width: 10.w,
                                //     ),
                                //     Container(
                                //       padding: EdgeInsets.symmetric(
                                //         horizontal: 8.h,
                                //         vertical: 5.h,
                                //       ),
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(15),
                                //         color: const Color.fromRGBO(
                                //             19, 59, 183, .14),
                                //       ),
                                //       child: Text(
                                //         (ride!.tripType == 'oneway')
                                //             ? 'One Way Trip'
                                //             : 'Return Trip',
                                //         style: GoogleFonts.poppins(
                                //           fontSize: 10,
                                //           color: const Color(0xff133BB7),
                                //           fontWeight: FontWeight.bold,
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
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
                                      'From: ${ride!.pickUpLocation}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
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
                                  crossAxisAlignment: WrapCrossAlignment.center,
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
                                      'Pick Up time:  ${ride!.pickUpTime}',
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
                                      'Arrival time: ${ride!.dropOffTime}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.h,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: getStatusColor(ride!.status)
                                            .withOpacity(0.14),
                                      ),
                                      child: Text(
                                        (ride!.status == 'booked')
                                            ? 'Ride Booked'
                                            : (ride!.status == 'completed')
                                                ? 'Ride Completed'
                                                : (ride!.status == 'cancelled')
                                                    ? 'Ride Cancelled'
                                                    : (ride!.status ==
                                                            'ongoing')
                                                        ? 'Ride in Progress'
                                                        : 'Status will be updated soon ...',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: getStatusColor(ride!.status),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
    );
  }
}
