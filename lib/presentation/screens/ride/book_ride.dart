import 'package:eaglerides/functions/function.dart';
import 'package:eaglerides/presentation/screens/ride/confirm_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../data/models/location_onboarding_data.dart';
import '../../../styles/styles.dart';
import '../../../widgets/custom_text_field_widget.dart';
import '../../controller/auth/auth_controller.dart';
import '../../controller/ride/ride_controller.dart';
import '../../../injection_container.dart' as di;
import '../account/child_registration.dart';
import 'address_search_screen.dart';

class BookRide extends StatefulWidget {
  const BookRide({super.key});

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  final AuthController _authController = Get.find();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController childController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final RideController _uberMapController = Get.put(di.sl<RideController>());
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController pickupTimeController = TextEditingController();
  final TextEditingController returnTimeController = TextEditingController();
  String? selectedChildId; // To store the selected child's ID
  String? selectedChildName; // To store the selected child's name
  String? selectedDriverType;
  String? selectedTripType;
  String? selectedSchedule;
  bool isLoading = true;
  bool idSelected = false;
  double? startLongitude;
  double? startLatitude;
  double? endLongitude;
  double? endLatitude;
  var user = Get.find<AuthController>().user.value;
  @override
  void dispose() {
    sourceController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    sourceController.text = user!.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Book a ride',
          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
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
                                  onTap: () async {
                                    print('tapped');
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddressSearchScreen(
                                          searchController: sourceController,
                                          // onLocationSelected:
                                          //     widget.onLocationSelected,
                                        ),
                                      ),
                                    );

                                    if (result != null &&
                                        result is LocationOnboardingData) {
                                      print('result');
                                      // print(result.latitude);
                                      // widget.onLocationSelected(result);
                                      setState(() {
                                        startLatitude = result.latitude;
                                        startLongitude = result.longitude;
                                      });
                                      print(startLatitude);
                                      print(startLongitude);
                                    }
                                  },
                                  // onChanged: (val) {
                                  //   _uberMapController.getPredictions(
                                  //       val, 'source');
                                  // },
                                  controller: sourceController,
                                  // ..text = _uberMapController
                                  //     .sourcePlaceName.value,
                                  obscureText: false,
                                  filled: true,
                                  keyboardType: TextInputType.text,
                                  hintText: 'Please enter pick up',
                                  readOnly: true,
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
                                  onTap: () async {
                                    print('tapped dropoff');
                                    final dropOff = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddressSearchScreen(
                                          searchController:
                                              destinationController,
                                          // onLocationSelected:
                                          //     widget.onLocationSelected,
                                        ),
                                      ),
                                    );

                                    if (dropOff != null &&
                                        dropOff is LocationOnboardingData) {
                                      print('result dropoff');
                                      // print(result.latitude);
                                      // widget.onLocationSelected(result);
                                      setState(() {
                                        endLatitude = dropOff.latitude;
                                        endLongitude = dropOff.longitude;
                                        // _currentLatLng = LatLng(
                                        //     result.latitude!,
                                        //     result.longitude!
                                        //     );
                                        // _mapController.animateCamera(
                                        //   CameraUpdate.newLatLng(
                                        //       _currentLatLng!),
                                        // );
                                      });
                                      print(endLatitude);
                                      print(endLongitude);
                                    }
                                  },
                                  // onChanged: (val) {
                                  //   _uberMapController.getPredictions(
                                  //       val, 'destination');
                                  // },
                                  controller: destinationController,
                                  // ..text = _uberMapController
                                  //     .destinationPlaceName.value,
                                  obscureText: false,
                                  filled: true,

                                  keyboardType: TextInputType.text,
                                  hintText: 'Please enter drop off',
                                  readOnly: true,
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
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Select Child',
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTextField(
                        onTap: () {
                          if (_authController.children.isEmpty) {
                            // Redirect to create child page if no children are available
                            Get.to(
                                const ChildRegistration()); // Replace with your navigation route
                          } else {
                            showModalBottomSheet(
                              isDismissible: true,
                              showDragHandle: true,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              context: context,
                              builder: (BuildContext context) {
                                return FractionallySizedBox(
                                  heightFactor: calculateHeightFactor(
                                      _authController.children.length),
                                  child: Card(
                                    child: Container(
                                      // height: 350,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(19)),
                                      child: ListView(
                                        children: [
                                          Text(
                                            'Select Child',
                                            style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                color: textColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: _authController
                                                  .children.length,
                                              itemBuilder: (context, idx) {
                                                return Column(
                                                  children: [
                                                    ListTileTheme(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 13.0,
                                                              right: 13.0,
                                                              top: 4,
                                                              bottom: 4),
                                                      selectedColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                      child: ListTile(
                                                        title: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              child: Text(
                                                                _authController
                                                                    .children[
                                                                        idx]
                                                                    .fullname,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      textColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            // idSelected = true;
                                                            selectedChildId =
                                                                _authController
                                                                    .children[
                                                                        idx]
                                                                    .id;
                                                            selectedChildName =
                                                                _authController
                                                                    .children[
                                                                        idx]
                                                                    .fullname;
                                                          });

                                                          childController.text =
                                                              _authController
                                                                  .children[idx]
                                                                  .fullname;

                                                          Navigator.pop(
                                                            context,
                                                          );

                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                    (idx !=
                                                            _authController
                                                                    .children
                                                                    .length -
                                                                1)
                                                        ? Divider(
                                                            color: greyColor,
                                                            height: 1,
                                                            indent: 13,
                                                            endIndent: 13,
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },

                        controller: childController,
                        // ..text = _uberMapController
                        //     .sourcePlaceName.value,
                        obscureText: false,
                        filled: true,
                        keyboardType: TextInputType.text,
                        hintText: 'Please select child',
                        readOnly: true,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add instruction label
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              'Please select driver type:',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Driver Type Row
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 13,
                            crossAxisSpacing: 13,
                            childAspectRatio: 3,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDriverType = 'freelance';
                                  });
                                },
                                child: Container(
                                  // height: 42,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedDriverType == 'freelance'
                                          ? Colors.black
                                          : Colors.grey.shade300,
                                      width: selectedDriverType == 'freelance'
                                          ? 2
                                          : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        selectedDriverType == 'freelance'
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Freelance Driver',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          letterSpacing: -.5,
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDriverType = 'inhouse';
                                  });
                                },
                                child: Container(
                                  // height: 42,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedDriverType == 'inhouse'
                                          ? Colors.black
                                          : Colors.grey.shade300,
                                      width: selectedDriverType == 'inhouse'
                                          ? 2
                                          : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        selectedDriverType == 'inhouse'
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'In-house Driver',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          letterSpacing: -.5,
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add instruction label
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              'Please select trip type:',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Driver Type Row
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 13,
                            crossAxisSpacing: 13,
                            childAspectRatio: 3,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTripType = 'one-way';
                                  });
                                },
                                child: Container(
                                  // height: 42,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedTripType == 'one-way'
                                          ? Colors.black
                                          : Colors.grey.shade300,
                                      width:
                                          selectedTripType == 'one-way' ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        selectedTripType == 'one-way'
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'One way Trip',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          letterSpacing: -.5,
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTripType = 'return';
                                  });
                                },
                                child: Container(
                                  // height: 42,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedTripType == 'return'
                                          ? Colors.black
                                          : Colors.grey.shade300,
                                      width:
                                          selectedTripType == 'return' ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        selectedTripType == 'return'
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Return Trip',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          letterSpacing: -.5,
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add instruction label
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              'Please select schedule:',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Driver Type Row
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 13,
                            crossAxisSpacing: 13,
                            childAspectRatio: 3,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSchedule = '2 weeks';
                                  });
                                },
                                child: Container(
                                  // height: 42,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedSchedule == '2 weeks'
                                          ? Colors.black
                                          : Colors.grey.shade300,
                                      width:
                                          selectedSchedule == '2 weeks' ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        selectedSchedule == '2 weeks'
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Two weeks',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          letterSpacing: -.5,
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSchedule = '1 month';
                                  });
                                },
                                child: Container(
                                  // height: 42,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedSchedule == '1 month'
                                          ? Colors.black
                                          : Colors.grey.shade300,
                                      width:
                                          selectedSchedule == '1 month' ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        selectedSchedule == '1 month'
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'One Month',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          letterSpacing: -.5,
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Column(
                    children: [
                      // Start Date Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Text(
                              'Start Date:',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 7,
                            child: CustomTextField(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  String formattedDate = formatDate(
                                      pickedDate); // Format as "3rd, July 2024"
                                  startDateController.text = formattedDate;
                                  print(startDateController.text);
                                }
                              },
                              controller: startDateController,
                              obscureText: false,
                              filled: true,
                              keyboardType: TextInputType.text,
                              hintText: 'Select date',
                              readOnly: true,
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

                      // Pickup Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Text(
                              'Pickup time:',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 7,
                            child: CustomTextField(
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  String formattedTime = formatTime(
                                      pickedTime, context); // Format with AM/PM
                                  pickupTimeController.text = formattedTime;
                                }
                                print(pickupTimeController.text);
                              },
                              controller: pickupTimeController,
                              obscureText: false,
                              filled: true,
                              keyboardType: TextInputType.text,
                              hintText: 'Select time',
                              readOnly: true,
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

                      // Return Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Text(
                              'Return time:',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 7,
                            child: CustomTextField(
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  String formattedTime = formatTime(
                                      pickedTime, context); // Format with AM/PM
                                  returnTimeController.text = formattedTime;
                                }
                              },
                              controller: returnTimeController,
                              obscureText: false,
                              filled: true,
                              keyboardType: TextInputType.text,
                              hintText: 'Select time',
                              readOnly: true,
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
                        if (sourceController.text.isEmpty) {
                          Get.snackbar(
                            'Invalid',
                            'Please enter your pickup location',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else if (destinationController.text.isEmpty) {
                          Get.snackbar(
                            'Invalid',
                            'Please enter your drop off location',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else if (childController.text.isEmpty) {
                          Get.snackbar(
                            'Invalid',
                            'Please select child',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else if (selectedDriverType == null) {
                          Get.snackbar(
                            'Invalid',
                            'Please select your driver type',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else if (selectedTripType == null) {
                          Get.snackbar(
                            'Invalid',
                            'Please select your trip type',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else if (selectedSchedule == null) {
                          Get.snackbar(
                            'Invalid',
                            'Please select your schedule',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else if (startDateController.text.isEmpty) {
                          Get.snackbar(
                            'Invalid',
                            'Please enter your start date',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else if (pickupTimeController.text.isEmpty) {
                          Get.snackbar(
                            'Invalid',
                            'Please enter your pick up time',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else if (returnTimeController.text.isEmpty) {
                          Get.snackbar(
                            'Invalid',
                            'Please enter your return time',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else {
                          Get.to(ConfirmBooking(
                            pickUpLatitude: startLatitude.toString(),
                            pickUpLongitude: startLongitude.toString(),
                            dropOffLatitude: endLatitude.toString(),
                            dropOffLongitude: endLongitude.toString(),
                            pickUpLocation: sourceController.text,
                            dropOffLocation: destinationController.text,
                            rideType: selectedDriverType!,
                            tripType: selectedTripType!,
                            schedule: selectedSchedule!,
                            startDate: startDateController.text.toString(),
                            pickUpTime: pickupTimeController.text.toString(),
                            returnTime: returnTimeController.text.toString(),
                            childName: selectedChildName!,
                            childId: selectedChildId!,
                          ));
                        }
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

  double calculateHeightFactor(int childrenCount) {
    // Minimum height factor is 0.6, increase by 0.1 for every 3 children
    double heightFactor = 0.6 + (childrenCount / 10);
    return heightFactor > 1.0 ? 1.0 : heightFactor; // Limit it to a max of 1.0
  }

  // Function to format date as "3rd, July 2024"
  String formatDate(DateTime date) {
    int day = date.day;
    String suffix = day == 1 || day == 21 || day == 31
        ? 'st'
        : (day == 2 || day == 22
            ? 'nd'
            : (day == 3 || day == 23 ? 'rd' : 'th'));

    // Format date
    String formattedDate = DateFormat('d MMMM yyyy').format(date);
    return '$day$suffix, ${formattedDate.substring(2)}'; // Append suffix to day
  }

// For Time Formatting
  String formatTime(TimeOfDay timeOfDay, BuildContext context) {
    // Convert TimeOfDay to DateTime
    final now = DateTime.now();
    final DateTime dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

    // Format time using intl package and return with AM/PM
    return DateFormat.jm().format(dateTime).toLowerCase();
  }
}
