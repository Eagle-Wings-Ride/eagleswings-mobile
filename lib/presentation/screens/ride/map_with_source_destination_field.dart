// import 'package:eaglerides/presentation/controller/ride/ride_controller.dart';
// import 'package:eaglerides/presentation/screens/home/home.dart';
// import 'package:eaglerides/styles/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../../injection_container.dart' as di;
// import 'widget/map_confirmation_bottom_sheet.dart';

// class MapWithSourceDestinationField extends StatefulWidget {
//   final CameraPosition defaultCameraPosition;
//   final CameraPosition newCameraPosition;

//   const MapWithSourceDestinationField(
//       {required this.newCameraPosition,
//       required this.defaultCameraPosition,
//       Key? key})
//       : super(key: key);

//   @override
//   _MapWithSourceDestinationFieldState createState() =>
//       _MapWithSourceDestinationFieldState();
// }

// class _MapWithSourceDestinationFieldState
//     extends State<MapWithSourceDestinationField> {
//   //final Completer<GoogleMapController> _controller = Completer();

//   final sourcePlaceController = TextEditingController();
//   final destinationController = TextEditingController();

//   final RideController _uberMapController = Get.put(di.sl<RideController>());

//   @override
//   void dispose() {
//     // Clean up the controller when the widget is disposed.
//     sourcePlaceController.dispose();
//     destinationController.dispose();
//     super.dispose();
//   }

// //   final sourcePlaceController = TextEditingController();
// //   final destinationController = TextEditingController();
// //   LatLng _initialPosition = LatLng(0, 0);
// //   bool _locationLoaded = false;
// //   GoogleMapController? mapController;
// //   final RideController _uberMapController = Get.put(di.sl<RideController>());

// //   @override
// //   void initState() {
// //     super.initState();
// //     _setInitialSourcePlace();
// //   }

// // void _setInitialSourcePlace() async {
// //     try {
// //       String _host = 'https://maps.google.com/maps/api/geocode/json';

// //       Position position = await Geolocator.getCurrentPosition(
// //           desiredAccuracy: LocationAccuracy.bestForNavigation);
// //       final url =
// //           '$_host?key=$apiKey&language=en&latlng=${position.latitude}, ${position.longitude}';
// //       var response = await http.get(Uri.parse(url));
// //       if (response.statusCode == 200) {
// //         Map data = jsonDecode(response.body);
// //         // print(data);
// //         String _formattedAddress = data['results'][0]['formatted_address'];
// //         print("response ===== $_formattedAddress");
// //         setState(() {
// //           sourcePlaceController.text = _formattedAddress;
// //           _uberMapController.sourcePlaceName.value = _formattedAddress;
// //           _initialPosition = LatLng(position.latitude, position.longitude);
// //           _locationLoaded = true;
// //           mapController!
// //               .animateCamera(CameraUpdate.newLatLng(_initialPosition));
// //         });
// //       } else {
// //         print('error');
// //         print(response.body);
// //       }
// //     } catch (e) {
// //       print(e);
// //     }
// //   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Get.offAll(() => const HomePage());
//         _uberMapController.subscription.cancel();
//         return true;
//       },
//       child: Scaffold(
//         // appBar: AppBar(),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Obx(
//                 () => Column(
//                   children: [
//                     Expanded(
//                       child: GoogleMap(
//                         mapType: MapType.terrain,
//                         initialCameraPosition: widget.defaultCameraPosition,
//                         myLocationButtonEnabled: true,
//                         myLocationEnabled: true,
//                         compassEnabled: true,
//                         // trafficEnabled: true,
//                         buildingsEnabled: true,
//                         markers: _uberMapController.markers.value.toSet(),
//                         polylines: {
//                           Polyline(
//                               polylineId: const PolylineId("polyLine"),
//                               visible: true,
//                               color: backgroundColor,
//                               width: 6,
//                               jointType: JointType.round,
//                               startCap: Cap.roundCap,
//                               endCap: Cap.roundCap,
//                               geodesic: true,
//                               points:
//                                   _uberMapController.polylineCoordinates.value),
//                           Polyline(
//                               polylineId:
//                                   const PolylineId("polyLineForAcptDriver"),
//                               color: Colors.black,
//                               width: 6,
//                               jointType: JointType.round,
//                               startCap: Cap.roundCap,
//                               endCap: Cap.roundCap,
//                               geodesic: true,
//                               points: _uberMapController
//                                   .polylineCoordinatesforacptDriver.value),
//                         },
//                         zoomControlsEnabled: false,
//                         zoomGesturesEnabled: true,
//                         onMapCreated: (GoogleMapController controller) {
//                           _uberMapController.controller.complete(controller);
//                           // controller.setMapStyle('assets/map_style_black.json');
//                           controller.animateCamera(
//                               CameraUpdate.newCameraPosition(
//                                   widget.newCameraPosition));
//                         },
//                       ),
//                     ),
//                     Visibility(
//                       visible:
//                           _uberMapController.isReadyToDisplayAvlDriver.value,
//                       child: const SizedBox(
//                           height: 250, child: MapConfirmationBottomSheet()),
//                     )
//                   ],
//                 ),
//               ),
//               Column(
//                 children: [
//                   Obx(
//                     () => Visibility(
//                       visible: !_uberMapController.isPoliLineDraw.value,
//                       child: Container(
//                         padding: const EdgeInsets.all(15),
//                         color: Colors.grey[300],
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: const BoxDecoration(
//                                   shape: BoxShape.circle, color: Colors.white),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   // _uberMapController.subscription.cancel();
//                                   Get.offAll(() => const HomePage());
//                                   _uberMapController.subscription.cancel();
//                                 },
//                                 child: const FaIcon(
//                                   FontAwesomeIcons.arrowLeft,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Container(
//                               margin:
//                                   const EdgeInsets.symmetric(horizontal: 15),
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               decoration: const BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(12))),
//                               child: TextField(
//                                 onChanged: (val) {
//                                   _uberMapController.getPredictions(
//                                       val, 'source');
//                                 },
//                                 decoration: const InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: "Enter Source Place"),
//                                 controller: sourcePlaceController
//                                   ..text =
//                                       _uberMapController.sourcePlaceName.value,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Container(
//                               margin:
//                                   const EdgeInsets.symmetric(horizontal: 15),
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               decoration: const BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(12))),
//                               child: TextField(
//                                 onChanged: (val) {
//                                   _uberMapController.getPredictions(
//                                       val, 'destination');
//                                 },
//                                 decoration: const InputDecoration(
//                                   hintText: "Enter Destination Place",
//                                   border: InputBorder.none,
//                                 ),
//                                 controller: destinationController
//                                   ..text = _uberMapController
//                                       .destinationPlaceName.value,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   //if (_uberMapController.uberMapPredictionData.isNotEmpty)
//                   Expanded(
//                     child: Obx(
//                       () => Visibility(
//                         visible:
//                             _uberMapController.uberMapPredictionData.isNotEmpty,
//                         child: Container(
//                           color: Colors.white,
//                           child: ListView.builder(
//                               //shrinkWrap: true,
//                               itemCount: _uberMapController
//                                   .uberMapPredictionData.length,
//                               itemBuilder: (context, index) {
//                                 return ListTile(
//                                   onTap: () async {
//                                     FocusScope.of(context).unfocus();
//                                     if (_uberMapController
//                                             .predictionListType.value ==
//                                         'source') {
//                                       _uberMapController
//                                           .setPlaceAndGetLocationDeatailsAndDirection(
//                                               sourcePlace: _uberMapController
//                                                   .uberMapPredictionData[index]
//                                                   .mainText
//                                                   .toString(),
//                                               destinationPlace: "");
//                                     } else {
//                                       _uberMapController
//                                           .setPlaceAndGetLocationDeatailsAndDirection(
//                                               sourcePlace: "",
//                                               destinationPlace:
//                                                   _uberMapController
//                                                       .uberMapPredictionData[
//                                                           index]
//                                                       .mainText
//                                                       .toString());
//                                     }
//                                   },
//                                   title: Text(_uberMapController
//                                       .uberMapPredictionData[index].mainText
//                                       .toString()),
//                                   subtitle: Text(_uberMapController
//                                       .uberMapPredictionData[index]
//                                       .secondaryText
//                                       .toString()),
//                                   trailing: const Icon(Icons.check),
//                                 );
//                               }),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Visibility(
//                 visible: _uberMapController.isDriverLoading.value,
//                 child: Container(
//                   alignment: Alignment.bottomCenter,
//                   margin: const EdgeInsets.only(bottom: 15),
//                   child: const Positioned(
//                       //bottom: 15,
//                       child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     //crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         color: Colors.black,
//                       ),
//                       Text(
//                         "  Loading Rides....",
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ],
//                   )),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
