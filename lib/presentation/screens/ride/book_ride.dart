import 'package:eaglerides/presentation/screens/ride/confirm_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../styles/styles.dart';
import '../../../widgets/custom_text_field_widget.dart';
import '../../controller/ride/ride_controller.dart';
import '../../../injection_container.dart' as di;

class BookRide extends StatefulWidget {
  const BookRide({super.key});

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final RideController _uberMapController = Get.put(di.sl<RideController>());
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController pickupTimeController = TextEditingController();
  final TextEditingController returnTimeController = TextEditingController();

  @override
  void dispose() {
    sourceController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Book a ride',
          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Container(
                              padding: EdgeInsets.all(10.sp),
                              decoration: BoxDecoration(
                                color: const Color(0xffF7F6F6),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.flag,
                                size: 15,
                              ),
                            ),
                            for (var i = 0; i < 10; i++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: Container(
                                  width: 2,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF7F6F6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            Container(
                              padding: EdgeInsets.all(10.sp),
                              decoration: BoxDecoration(
                                color: const Color(0xffF7F6F6),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Flexible(
                        flex: 9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pick-up location',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                CustomTextField(
                                  onChanged: (val) {
                                    _uberMapController.getPredictions(
                                        val, 'source');
                                  },
                                  controller: sourceController
                                    ..text = _uberMapController
                                        .sourcePlaceName.value,
                                  obscureText: false,
                                  filled: true,
                                  keyboardType: TextInputType.text,
                                  hintText: 'Please enter pick up',
                                  readOnly: false,
                                  suffixIcon: const Icon(
                                    Icons.my_location_outlined,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            for (var i = 0; i < 5; i++)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 1),
                                child: SizedBox(
                                  width: 2,
                                  height: 5,
                                ),
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Drop-off location',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                CustomTextField(
                                  onChanged: (val) {
                                    _uberMapController.getPredictions(
                                        val, 'destination');
                                  },
                                  controller: destinationController
                                    ..text = _uberMapController
                                        .destinationPlaceName.value,
                                  obscureText: false,
                                  filled: true,
                                  keyboardType: TextInputType.text,
                                  hintText: 'Please enter drop off',
                                  readOnly: false,
                                  suffixIcon: const Icon(
                                    Icons.my_location_outlined,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 45.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Booking Details',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
                          //         color: const Color.fromRGBO(19, 59, 183, .14),
                          //       ),
                          //       child: Text(
                          //         'For you',
                          //         style: GoogleFonts.poppins(
                          //           fontSize: 10,
                          //           color: const Color(0xff133BB7),
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       width: 15.w,
                          //     ),
                          //     Text(
                          //       'For others',
                          //       style: GoogleFonts.poppins(
                          //         fontSize: 10,
                          //         fontWeight: FontWeight.bold,
                          //         color: textColor,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Ride Type',
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.h,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color.fromRGBO(19, 59, 183, .14),
                                ),
                                child: Text(
                                  'Freelance Driver',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: const Color(0xff133BB7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.h,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color.fromRGBO(255, 85, 0, .14),
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
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.h,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color.fromRGBO(19, 59, 183, .14),
                                ),
                                child: Text(
                                  'One way trip',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: const Color(0xffFF5500),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.h,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color.fromRGBO(19, 59, 183, .14),
                                ),
                                child: Text(
                                  'Return trip',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: const Color(0xffFF5500),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Schedule',
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 10.h,
                            ),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.h,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color:
                                        const Color.fromRGBO(19, 59, 183, .14),
                                  ),
                                  child: Text(
                                    'Two Weeks',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: const Color(0xff133BB7),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.h,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color:
                                        const Color.fromRGBO(19, 59, 183, .14),
                                  ),
                                  child: Text(
                                    'One Month',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: const Color(0xff133BB7),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                Text(
                                  'Enter Manually',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: const Color(0xff133BB7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 4,
                            child: Text(
                              'Start Date:',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 10.w,
                          // ),
                          Flexible(
                            flex: 6,
                            child: CustomTextField(
                              onChanged: (val) {
                                // _uberMapController.getPredictions(
                                //     val, 'source');
                              },
                              controller: startDateController,
                              obscureText: false,
                              filled: true,
                              keyboardType: TextInputType.text,
                              hintText: 'Enter date here',
                              readOnly: false,
                              prefixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 4,
                            child: Text(
                              'Pickup time:',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 10.w,
                          // ),
                          Flexible(
                            flex: 6,
                            child: CustomTextField(
                              onChanged: (val) {},
                              controller: pickupTimeController,
                              obscureText: false,
                              filled: true,
                              keyboardType: TextInputType.text,
                              hintText: 'Enter time here',
                              readOnly: false,
                              prefixIcon: const Icon(
                                Icons.access_time,
                                color: Colors.black,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 4,
                            child: Text(
                              'Return time:',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 10.w,
                          // ),
                          Flexible(
                            flex: 6,
                            child: CustomTextField(
                              onChanged: (val) {},
                              controller: returnTimeController,
                              obscureText: false,
                              filled: true,
                              keyboardType: TextInputType.text,
                              hintText: 'Enter time here',
                              readOnly: false,
                              prefixIcon: const Icon(
                                Icons.access_time,
                                color: Colors.black,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width - 100, 50),
                        backgroundColor: backgroundColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Get.to(ConfirmBooking());
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
