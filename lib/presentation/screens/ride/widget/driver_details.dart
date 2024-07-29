import 'package:eaglerides/presentation/controller/ride/ride_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class DriverDetails extends StatelessWidget {
  final RideController rideController;

  const DriverDetails({required this.rideController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
            color: Color(0xfff7f6fb),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(rideController
                      .req_accepted_driver_and_vehicle_data["profile_img"]
                      .toString()),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rideController
                          .req_accepted_driver_and_vehicle_data["name"]
                          .toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${rideController.req_accepted_driver_and_vehicle_data["overall_rating"]} ⭐",
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.blueAccent),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    String mobile = rideController
                        .req_accepted_driver_and_vehicle_data["mobile"]
                        .toString();
                    await FlutterPhoneDirectCaller.callNumber(mobile);
                  },
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.call),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  rideController.req_accepted_driver_and_vehicle_data[
                          "vehicle_number_plate"]
                      .toString(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "color :${rideController.req_accepted_driver_and_vehicle_data["vehicle_color"]}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "model :${rideController.req_accepted_driver_and_vehicle_data["vehicle_model"]}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "company :${rideController.req_accepted_driver_and_vehicle_data["vehicle_company"]}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
