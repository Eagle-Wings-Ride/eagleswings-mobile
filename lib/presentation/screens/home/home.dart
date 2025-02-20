import 'package:eaglerides/core/utils/format_date.dart';
import 'package:eaglerides/data/models/book_rides_model.dart';
import 'package:eaglerides/presentation/controller/auth/auth_controller.dart';
import 'package:eaglerides/presentation/screens/ride/book_ride.dart';
import 'package:eaglerides/presentation/screens/ride/widget/custom_loader.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/utils/get_status.dart';
import '../../../data/models/child_model.dart';
import '../../../injection_container.dart' as di;
import '../../../styles/styles.dart';
import '../../controller/home/home_controller.dart';
import '../account/child_registration.dart';
import '../ride/rides_screen.dart';
import '../ride/single_ride_info_screen.dart';
// import '../ride/map_with_source_destination_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  void getLocs() {
    // locationFromAddress(address)
  }
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.put(di.sl<HomeController>());
  List<Booking> childrenList = []; // List of Child objects
  String? selectedChildId; // To store the selected child's ID
  String? selectedChildName; // To store the selected child's name
  bool isLoading = true;
  bool idSelected = false;
  final AuthController _authController = Get.find();

  @override
  void initState() {
    _homeController.getUserCurrentLocation();

    fetchChildrenData();
    _authController.fetchRatesData();
    super.initState();
  }

  Future<void> fetchChildrenData() async {
    try {
      await _authController.fetchChildren();

      setState(() {
        if (_authController.children.isNotEmpty) {
          selectedChildId = _authController.children.first.id;
          selectedChildName = _authController.children.first.fullname;
        } else {
          selectedChildId = null;
          selectedChildName = null;
        }
        isLoading = false;
      });
      await _authController.fetchRecentRides(selectedChildId!);
      setState(() {
        childrenList = _authController.recentRides;
      });
      // print('childrenList');
      // print(childrenList);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // print('Error fetching children: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEFEFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildAppBar(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 33.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isDismissible: true,
                            showDragHandle: true,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            context: context,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.6,
                                child: Card(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(19),
                                    ),
                                    child: _authController.rates.value == null
                                        ? const Center(
                                            child: CustomLoader(),
                                          ) // Loading spinner
                                        : ListView(
                                            children: [
                                              Text(
                                                'Trip Rates',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  color: textColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    2, // Two driver types
                                                itemBuilder: (context, idx) {
                                                  String driverType = idx == 0
                                                      ? 'in_house_drivers'
                                                      : 'freelance_drivers';
                                                  return Column(
                                                    children: [
                                                      ListTile(
                                                        title: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                                width: 8),
                                                            Text(
                                                              "${driverType == 'in_house_drivers' ? 'In-House' : 'Freelance'} Drivers",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    textColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    16.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "One Way: \$${_authController.rates.value?[driverType]['one_way'] ?? 'N/A'}",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    backgroundColor,
                                                              ),
                                                            ),
                                                            Text(
                                                              "Return: \$${_authController.rates.value?[driverType]['return'] ?? 'N/A'}",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    backgroundColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // const Divider(),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: quickButtons('check_rates', 'Check rates'),
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.to(const BookRide());
                          },
                          child: quickButtons('book_rides', 'Book rides')),
                      quickButtons('track_rides', 'Track rides'),
                      GestureDetector(
                          onTap: () {
                            Get.to(const ChildRegistration());
                          },
                          child: quickButtons('history', 'Create Child')),
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _authController.children.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'No children found. Please create a child to view recent rides.',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width - 100,
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
                                  // Navigate to create child screen
                                  Get.to(const ChildRegistration());
                                },
                                child: Text(
                                  'Create Child',
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
                        )
                      : selectedChildId == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Please select a child to see recent rides.',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 20),
                                  DropdownButton<String>(
                                    value: selectedChildId,
                                    onChanged: (newChildId) {
                                      setState(() {
                                        selectedChildId = newChildId;
                                      });
                                      _authController
                                          .fetchRecentRides(newChildId!);
                                    },
                                    items: _authController.children
                                        .map(
                                            (child) => DropdownMenuItem<String>(
                                                  value: child.id,
                                                  child: Text(child.fullname),
                                                ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            )
                          : (childrenList.isEmpty)
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No Recent activities yet',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Ride History',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                              ),
                                              Text(
                                                'See all',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: textColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: childrenList.length,
                                      itemBuilder: (context, index) {
                                        final ride = childrenList[index];
                                        // print('ride');
                                        // print(ride);
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                    const SingleRideInfoScreen(),
                                                    arguments: {
                                                      'rideId': ride.id
                                                    });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w,
                                                    vertical: 5.h),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: page,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(
                                                          9, 39, 127, .15),
                                                      blurRadius: 30.0,
                                                      spreadRadius: -4.0,
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      flex: 9,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        // main
                                                        children: [
                                                          Flexible(
                                                            flex: 2,
                                                            child: ClipOval(
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/rides_img.jpg',
                                                                width: 45,
                                                                height: 45,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 15.w),
                                                          Flexible(
                                                            flex: 8,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  '${ride.pickUpLocation} to ${ride.dropOffLocation}',
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        textColor,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8.h,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              5,
                                                                          vertical:
                                                                              3),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: getRideTypeColor(ride.rideType)
                                                                            .withOpacity(0.14),
                                                                        borderRadius:
                                                                            BorderRadius.circular(40),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        ride.rideType
                                                                            .capitalizeFirst!,
                                                                        style: GoogleFonts.poppins(
                                                                            color: getRideTypeColor(ride
                                                                                .rideType),
                                                                            fontSize:
                                                                                8,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          6.w,
                                                                    ),
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              5,
                                                                          vertical:
                                                                              3),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: getStatusColor(ride.status.toLowerCase())
                                                                            .withOpacity(0.15),
                                                                        borderRadius:
                                                                            BorderRadius.circular(40),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        ride.status,
                                                                        style: GoogleFonts.poppins(
                                                                            color: getStatusColor(ride.status
                                                                                .toLowerCase()),
                                                                            fontSize:
                                                                                8,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 8.h,
                                                                ),
                                                                Text(
                                                                  formatDate(ride
                                                                      .createdAt),
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color:
                                                                        textColor,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // const Flexible(
                                                    //   flex: 2,
                                                    //   child: Icon(
                                                    //     Icons.more_horiz,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12.h,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column quickButtons(String image, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Image.asset(
            'assets/images/$image.png',
            width: 35,
            height: 35,
          ),
        ),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Container buildAppBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        color: backgroundColor,
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 22.w),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(148, 163, 208, 0.2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My location',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Obx(
                    () => Row(
                      // crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(148, 163, 208, 0.2),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Flexible(
                          flex: 8,
                          child: Text(
                            _homeController.address.value.isNotEmpty
                                ? _homeController.address.value
                                : 'Fetching address...',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 32.h,
                ),
                Image.asset(
                  'assets/images/app_name_white.png',
                  height: 12.h,
                  width: 48.w,
                ),
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
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
                                            color: Theme.of(context).cardColor,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                _authController.children.length,
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
                                                                  .children[idx]
                                                                  .fullname,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts
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
                                                      onTap: () async {
                                                        setState(() {
                                                          // idSelected = true;
                                                          selectedChildId =
                                                              _authController
                                                                  .children[idx]
                                                                  .id;
                                                          selectedChildName =
                                                              _authController
                                                                  .children[idx]
                                                                  .fullname;
                                                        });
                                                        await _authController
                                                            .fetchRecentRides(
                                                                _authController
                                                                    .children[
                                                                        idx]
                                                                    .id);

                                                        // _genderController.text =
                                                        //     childrenList[idx];
                                                        childrenList =
                                                            _authController
                                                                .recentRides;
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(148, 163, 208, 0.2),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.profile_circle,
                              color: Colors.white.withOpacity(.7),
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: selectedChildName != null
                                  ? Text(
                                      'Hello $selectedChildName',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white.withOpacity(.7),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Get.to(
                                            const ChildRegistration()); // Navigate to create child page
                                      },
                                      child: Text(
                                        'No child available.',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(.7),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                              color: Colors.white.withOpacity(.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(148, 163, 208, 0.2),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.white.withOpacity(.7),
                        size: 26,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Ready for a Safe Ride?',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(const BookRide());
                  },
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Let’s book a ride for your child.',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Image.asset(
                        'assets/images/arrow_forward.png',
                        width: 20,
                        color: Colors.white.withOpacity(.7),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 70.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calculateHeightFactor(int childrenCount) {
    // Minimum height factor is 0.6, increase by 0.1 for every 3 children
    double heightFactor = 0.6 + (childrenCount / 10);
    return heightFactor > 1.0 ? 1.0 : heightFactor; // Limit it to a max of 1.0
  }
}
