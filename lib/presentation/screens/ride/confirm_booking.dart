import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../injection_container.dart' as di;
import '../../../styles/styles.dart';
import '../../controller/ride/ride_controller.dart';

class ConfirmBooking extends StatefulWidget {
  const ConfirmBooking({super.key});

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(23.030357, 72.517845),
    zoom: 14.4746,
  );

  final RideController _uberMapController = Get.put(di.sl<RideController>());

  bool _isPopupVisible = false;

  void _togglePopup() {
    setState(() {
      _isPopupVisible = !_isPopupVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              Positioned.fill(
                child: GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition: _defaultLocation,
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
                        CameraUpdate.newCameraPosition(_defaultLocation));
                  },
                ),
              ),
              // Draggable Container
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
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        // color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 40, horizontal: 25),
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
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xffF7F6F6),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: const Icon(
                                                Icons.flag,
                                                size: 15,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '102, Fox Drive',
                                              style: GoogleFonts.dmSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: textColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        for (var i = 0; i < 15; i++)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 1, horizontal: 20),
                                            child: Container(
                                              width: 2,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color: const Color(0xffF7F6F6),
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
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xffF7F6F6),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: const Icon(
                                                Icons.location_on_outlined,
                                                size: 15,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Millennium Drive',
                                              style: GoogleFonts.dmSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: textColor,
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
                                            style: GoogleFonts.dmSans(
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
                                            style: GoogleFonts.dmSans(
                                              fontSize: 10,
                                              color: const Color(0xff133BB7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
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
      ),
    );
  }
}
