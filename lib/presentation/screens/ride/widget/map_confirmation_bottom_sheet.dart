// import 'package:eaglerides/presentation/controller/ride/ride_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:lottie/lottie.dart';
// import '../../../../injection_container.dart' as di;
// import 'driver_details.dart';

// class MapConfirmationBottomSheet extends StatelessWidget {
//   const MapConfirmationBottomSheet({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final RideController _rideController = Get.put(di.sl<RideController>());
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Obx(
//         () => Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Flexible(
//                     child: Text(
//                       _rideController.sourcePlaceName.value.toString(),
//                       style: const TextStyle(
//                           fontWeight: FontWeight.w700, fontSize: 25),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const FaIcon(FontAwesomeIcons.longArrowAltRight),
//                   Flexible(
//                     child: Text(
//                       _rideController.destinationPlaceName.value.toString(),
//                       style: const TextStyle(
//                           fontWeight: FontWeight.w700, fontSize: 25),
//                       overflow: TextOverflow.ellipsis,
//                       //maxLines: 3,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text(
//                   _rideController.uberMapDirectionData[0].distanceText
//                       .toString(),
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w300, fontSize: 15),
//                 ),
//                 Text(
//                   _rideController.uberMapDirectionData[0].durationText
//                       .toString(),
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w300, fontSize: 15),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Expanded(
//               child: _rideController.reqAccepted.value
//                   ? DriverDetails(rideController: _rideController)
//                   : _rideController.findDriverLoading.value
//                       ? Lottie.network(
//                           'https://assets9.lottiefiles.com/packages/lf20_ubozqrue.json')
//                       : ListView.builder(
//                           //shrinkWrap: true,
//                           itemCount: _rideController
//                               .availableDriversList.value.length, //2
//                           itemBuilder: (context, index) {
//                             return Container(
//                               margin: const EdgeInsets.all(15),
//                               color: Colors.grey[100],
//                               child: ListTile(
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 20.0, vertical: 10.0),
//                                 leading: Container(
//                                     width: 85,
//                                     padding: const EdgeInsets.only(right: 12.0),
//                                     decoration: const BoxDecoration(
//                                         border: Border(
//                                             right: BorderSide(
//                                                 width: 1.0,
//                                                 color: Colors.black38))),
//                                     child: _rideController.availableDriversList
//                                                 .value[index].vehicle!.path
//                                                 .split('/')
//                                                 .first ==
//                                             'cars'
//                                         ? Image.asset("assets/car.png")
//                                         : _rideController.availableDriversList
//                                                     .value[index].vehicle!.path
//                                                     .split('/')
//                                                     .first ==
//                                                 'auto'
//                                             ? Image.asset(
//                                                 'assets/auto.png',
//                                               )
//                                             : Image.asset(
//                                                 'assets/bike.png',
//                                               )),
//                                 title: Text(
//                                   _rideController
//                                       .availableDriversList.value[index].name
//                                       .toString(),
//                                   // style: const TextStyle(
//                                   //     color: Colors.black, fontWeight: FontWeight.bold),
//                                 ),
//                                 subtitle: _rideController.availableDriversList
//                                             .value[index].vehicle!.path
//                                             .split('/')
//                                             .first ==
//                                         'cars'
//                                     ? Text(
//                                         '\$ ${_rideController.freelanceRent.value}')
//                                     : _rideController.availableDriversList
//                                                 .value[index].vehicle!.path
//                                                 .split('/')
//                                                 .first ==
//                                             'auto'
//                                         ? Text(
//                                             '\$ ${_rideController.inHouseRent.value}')
//                                         : Text(
//                                             '\$ ${_rideController.oneWayRent.value}'),
//                                 trailing: Text(
//                                     "${_rideController.availableDriversList.value[index].overall_rating} ⭐"),
//                                 onTap: () {
//                                   _rideController.generateTrip(
//                                       _rideController
//                                           .availableDriversList.value[index],
//                                       index);
//                                 },
//                               ),
//                             );
//                           }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
