// import 'dart:typed_data';
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:eaglerides/core/utils/get_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../injection_container.dart' as di;
import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';
import '../../controller/ride/ride_controller.dart';

class ConfirmBooking extends StatefulWidget {
  final String pickUpLatitude,
      pickUpLongitude,
      dropOffLatitude,
      dropOffLongitude,
      pickUpLocation,
      dropOffLocation,
      rideType,
      tripType,
      schedule,
      startDate,
      pickUpTime,
      returnTime,
      childName,
      childId;

  const ConfirmBooking(
      {super.key,
      required this.pickUpLatitude,
      required this.pickUpLongitude,
      required this.dropOffLatitude,
      required this.dropOffLongitude,
      required this.pickUpLocation,
      required this.dropOffLocation,
      required this.rideType,
      required this.tripType,
      required this.schedule,
      required this.startDate,
      required this.pickUpTime,
      required this.returnTime,
      required this.childName,
      required this.childId});

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  final AuthController _authController = Get.find();
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor? _pickupIcon;
  BitmapDescriptor? _dropOffIcon;
  String mapStyle = '';
  // static CameraPosition _defaultLocation = CameraPosition(
  //   target: LatLng(double.tryParse(widget.pickUpLatitude.toString()),
  //       double.tryParse(widget.pickUpLongitude.toString())),
  //   zoom: 14.4746,
  // );

  // final RideController _uberMapController = Get.put(di.sl<RideController>());

  @override
  void initState() {
    super.initState();
    _loadCustomMarkers();
    rootBundle.loadString('assets/map_style_black.json').then((string) {
      mapStyle = string;
    });
    // _loadMapStyle().then((style) {
    //   setState(() {
    //     mapStyle = style;
    //   });
    // });
  }

  bool _isPopupVisible = false;

  void _togglePopup() {
    setState(() {
      _isPopupVisible = !_isPopupVisible;
    });
  }

  // Load the map style from assets
  Future<String> _loadMapStyle() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json'); // Load your map style JSON file
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GoogleMap(
                mapType: MapType.terrain,
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(widget.dropOffLatitude),
                      double.parse(widget.dropOffLatitude)),
                  zoom: 17.4746,
                ),
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                compassEnabled: true,
                buildingsEnabled: true,
                markers: {
                  if (_pickupIcon != null)
                    Marker(
                      markerId: const MarkerId("pickup"),
                      position: LatLng(
                        double.parse(widget.pickUpLatitude),
                        double.parse(widget.pickUpLongitude),
                      ),
                      // infoWindow: const InfoWindow(title: "Pickup Location"),
                      infoWindow: InfoWindow(
                        title: widget.pickUpLocation,
                        snippet: "This is the pickup location",
                      ),

                      icon: _pickupIcon!,
                    ),
                  if (_dropOffIcon != null)
                    Marker(
                      // draggable: true,
                      markerId: const MarkerId("dropoff"),
                      position: LatLng(
                        double.parse(widget.dropOffLatitude),
                        double.parse(widget.dropOffLongitude),
                      ),
                      infoWindow: InfoWindow(
                        title: widget.dropOffLocation,
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
                      LatLng(double.parse(widget.pickUpLatitude),
                          double.parse(widget.pickUpLongitude)),
                      LatLng(double.parse(widget.dropOffLatitude),
                          double.parse(widget.dropOffLongitude)),
                    ], // Ensure both pickup and drop-off are included
                  ),
                },
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                style: mapStyle,
                onMapCreated: (GoogleMapController controller) async {
                  controller.setMapStyle(mapStyle);
                  // GoogleMap.style();
                  // _controller.future.then((value) {
                  //   value.setMapStyle(mapStyle);
                  // });
                  // controller.setMapStyle(mapStyle);
                  // controller.GoogleMap.style('assets/map_style.json');
                  controller.showMarkerInfoWindow(const MarkerId('pickup'));
                  _controller.complete(controller);

                  LatLng pickupLocation = LatLng(
                    double.parse(widget.pickUpLatitude),
                    double.parse(widget.pickUpLongitude),
                  );

                  LatLng dropOffLocation = LatLng(
                    double.parse(widget.dropOffLatitude),
                    double.parse(widget.dropOffLongitude),
                  );

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
            // Draggable Container
            DraggableScrollableSheet(
              initialChildSize: 0.4, // 60% of the screen height when expanded
              minChildSize: 0.3, // Minimum height when collapsed
              maxChildSize: 0.6, // Maximum drag size
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  // height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    // color: textColor,
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  // color: Colors.white,
                  child: Column(
                    children: [
                      // Positioned container at the top of the draggable sheet
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        height: 25,
                        decoration: BoxDecoration(
                          color: textColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Please allow for up to 5mins to assign a driver to you',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Confirm Your Booking',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffF7F6F6),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: const Icon(
                                                  Icons.flag,
                                                  size: 15,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                child: Text(
                                                  widget.pickUpLocation,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: textColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          for (var i = 0; i < 5; i++)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1,
                                                      horizontal: 20),
                                              child: Container(
                                                width: 2,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffF7F6F6),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffF7F6F6),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: const Icon(
                                                  Icons.location_on_outlined,
                                                  size: 15,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                child: Text(
                                                  widget.dropOffLocation,
                                                  // overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: textColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                Text(
                                  'Other details',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
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
                                        blurRadius:
                                            5, // The softness of the shadow
                                        offset: const Offset(3,
                                            3), // Position of shadow: x, y (right, down)
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${widget.pickUpLocation} To ${widget.dropOffLocation}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
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
                                              color: getRideTypeColor(
                                                      widget.rideType)
                                                  .withOpacity(0.14),
                                            ),
                                            child: Text(
                                              (widget.rideType == 'inhouse')
                                                  ? 'In-house driver'
                                                  : 'Freelance Driver',
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                color: getRideTypeColor(
                                                    widget.rideType),
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
                                              (widget.tripType == 'oneway')
                                                  ? 'One Way Trip'
                                                  : 'Return Trip',
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
                                          SvgPicture.asset(
                                            'assets/images/duration_icon.svg',
                                            width: 20,
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            widget.schedule,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          SvgPicture.asset(
                                            'assets/images/child_icon.svg',
                                            width: 20,
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            widget.childName,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
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
                                            'Pick Up time: ${widget.pickUpTime}',
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
                                            'Arrival time: ${widget.returnTime}',
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
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text(
                                          'Cancel',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                .4,
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
                                        _authController.bookRide({
                                          "pick_up_location":
                                              widget.pickUpLocation,
                                          "drop_off_location":
                                              widget.dropOffLocation,
                                          "ride_type": widget.rideType,
                                          "trip_type": widget.tripType,
                                          "schedule": widget.schedule,
                                          "start_date": widget.startDate,
                                          "pick_up_time": widget.pickUpTime,
                                          "drop_off_time": widget.returnTime,
                                          "start_longitude":
                                              widget.pickUpLongitude,
                                          "start_latitude":
                                              widget.pickUpLatitude,
                                          "end_longitude":
                                              widget.dropOffLongitude,
                                          "end_latitude": widget.dropOffLatitude
                                        }, widget.childId, context);
                                      },
                                      child: Text(
                                        'Confirm',
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
                        size: 20,
                        fill: 0.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_isPopupVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Popup Content',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      ElevatedButton(
                        onPressed: _togglePopup,
                        child: const Text('Close Popup'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String convertDateFormat(String dateStr) {
  // Remove the day suffix (st, nd, rd, th)
  final day = dateStr.split(',')[0].replaceAll(RegExp(r'\D'), '');
  final monthYear = dateStr.split(',')[1].trim();
  final month = monthYear.split(' ')[0];
  final year = monthYear.split(' ')[1];

  // Create the final formatted string
  final formattedDate = '$day $month, $year';

  // Parse the date and format it to the desired format
  DateFormat inputFormat = DateFormat('d MMMM, yyyy');
  DateFormat outputFormat = DateFormat('dd/MM/yyyy');
  DateTime dateTime = inputFormat.parse(formattedDate);

  return outputFormat.format(dateTime);
}
