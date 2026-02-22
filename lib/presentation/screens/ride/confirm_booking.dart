// import 'dart:typed_data';
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:eaglerides/core/utils/get_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';

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
  // ⭐ ADD THESE NEW PARAMETERS:
  final List<String> pickupDays;
  final String morningFrom,
      morningTo,
      morningFromAddress,
      morningToAddress,
      afternoonFrom,
      afternoonTo,
      afternoonFromAddress,
      afternoonToAddress;

  const ConfirmBooking({
    super.key,
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
    required this.childId,
    // ⭐ ADD THESE TO CONSTRUCTOR:
    required this.pickupDays,
    required this.morningFrom,
    required this.morningTo,
    required this.morningFromAddress,
    required this.morningToAddress,
    required this.afternoonFrom,
    required this.afternoonTo,
    required this.afternoonFromAddress,
    required this.afternoonToAddress,
  });

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
  }

  bool _isPopupVisible = false;

  void _togglePopup() {
    setState(() {
      _isPopupVisible = !_isPopupVisible;
    });
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
                  // Small delay to ensure markers are ready on the map
                  Future.delayed(const Duration(milliseconds: 500), () {
                    controller.showMarkerInfoWindow(const MarkerId('pickup'));
                  });
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
                              fontSize: 12,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Confirm Your Booking',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: backgroundColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Step 5 of 5',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: backgroundColor,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                        children: [
                                          const SizedBox(height: 24),
                                          _buildRoutePoint(
                                            icon: Iconsax.location,
                                            color: Colors.green,
                                            address: widget.pickUpLocation,
                                            label: 'Pickup',
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 17.w),
                                            child: Container(
                                              width: 2,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.green,
                                                    Colors.red
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                              ),
                                            ),
                                          ),
                                          _buildRoutePoint(
                                            icon: Iconsax.location_tick,
                                            color: Colors.red,
                                            address: widget.dropOffLocation,
                                            label: 'Drop-off',
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
                                  height: 24,
                                ),
                                _buildSectionHeader('Other details'),
                                const SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(20.sp),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey[100]!,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          _buildDetailChip(
                                            label: widget.rideType == 'inhouse'
                                                ? 'In-house driver'
                                                : 'Freelance Driver',
                                            color: getRideTypeColor(
                                                widget.rideType),
                                          ),
                                          SizedBox(width: 8.w),
                                          _buildDetailChip(
                                            label: widget.tripType == 'oneway'
                                                ? 'One Way Trip'
                                                : 'Return Trip',
                                            color: const Color(0xff133BB7),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          const Icon(Iconsax.calendar,
                                              size: 20, color: Colors.grey),
                                          SizedBox(width: 8.w),
                                          Text(
                                            widget.schedule,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          const Icon(Iconsax.user,
                                              size: 20, color: Colors.grey),
                                          SizedBox(width: 8.w),
                                          Text(
                                            widget.childName,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          const Icon(Iconsax.clock,
                                              size: 20, color: Colors.grey),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'Pickup: ${widget.pickUpTime}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: textColor,
                                            ),
                                          ),
                                          if (widget.tripType == 'return') ...[
                                            SizedBox(width: 16.w),
                                            Text(
                                              'Return: ${widget.returnTime}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: textColor,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              Navigator.of(context).pop(),
                                          child: Container(
                                            height: 56.h,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              'Cancel',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            _authController.bookRide({
                                              "ride_type": widget.rideType,
                                              "trip_type": widget.tripType,
                                              "schedule_type": widget.schedule,
                                              "pickup_days": widget.pickupDays,
                                              "start_date": _convertDateFormat(
                                                  widget.startDate),
                                              "morning_from":
                                                  widget.morningFrom,
                                              "morning_to": widget.morningTo,
                                              "morning_time": widget.pickUpTime,
                                              "morning_from_address":
                                                  widget.morningFromAddress,
                                              "morning_to_address":
                                                  widget.morningToAddress,
                                              "afternoon_from":
                                                  widget.afternoonFrom,
                                              "afternoon_to":
                                                  widget.afternoonTo,
                                              "afternoon_time":
                                                  widget.returnTime,
                                              "afternoon_from_address":
                                                  widget.afternoonFromAddress,
                                              "afternoon_to_address":
                                                  widget.afternoonToAddress,
                                              "start_longitude":
                                                  widget.pickUpLongitude,
                                              "start_latitude":
                                                  widget.pickUpLatitude,
                                              "end_longitude":
                                                  widget.dropOffLongitude,
                                              "end_latitude":
                                                  widget.dropOffLatitude,
                                            }, widget.childId, context);
                                          },
                                          child: Container(
                                            height: 56.h,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  backgroundColor,
                                                  backgroundColor
                                                      .withOpacity(0.9)
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: backgroundColor
                                                      .withOpacity(0.3),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              'Confirm Booking',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 16,
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

  Widget _buildDetailChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: backgroundColor,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildRoutePoint({
    required IconData icon,
    required Color color,
    required String address,
    required String label,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textColor.withOpacity(0.5),
                ),
              ),
              Text(
                address,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _convertDateFormat(String dateStr) {
  try {
    if (RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$').hasMatch(dateStr)) {
      return dateStr;
    }

    DateFormat inputFormat = DateFormat('d MMMM, yyyy');
    DateTime dateTime = inputFormat.parse(dateStr);
    DateFormat outputFormat = DateFormat('MM/dd/yyyy');
    return outputFormat.format(dateTime);
  } catch (e) {
    return dateStr;
  }
}
