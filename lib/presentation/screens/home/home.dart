import 'package:eaglerides/presentation/controller/auth/auth_controller.dart';
import 'package:eaglerides/presentation/screens/ride/book_ride.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import '../../../injection_container.dart' as di;
import '../../../styles/styles.dart';
import '../../controller/home/home_controller.dart';
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
  // final AuthController _authController = Get.find();
  // String address = '';
  // static const CameraPosition _defaultLocation = CameraPosition(
  //   target: LatLng(23.030357, 72.517845),
  //   zoom: 14.4746,
  // );

  @override
  void initState() {
    _homeController.getUserCurrentLocation();
    // _homeController.startLocationUpdates();
    // setState(() {
    //   address = _homeController.address.value;
    // });
    // _authController.getUser(context);
    super.initState();
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
                        onTap: () {},
                        child: quickButtons('check_rates', 'Check rates'),
                      ),
                      GestureDetector(
                          onTap: () {
                            // Get.to(
                            //   () => const MapWithSourceDestinationField(
                            //     newCameraPosition: _defaultLocation,
                            //     defaultCameraPosition: _defaultLocation,
                            //   ),
                            // );
                            Get.to(const BookRide());
                          },
                          child: quickButtons('book_rides', 'Book rides')),
                      quickButtons('track_rides', 'Track rides'),
                      quickButtons('history', 'History'),
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  SizedBox(
                    height: 13.h,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: page,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(9, 39, 127, .15),
                                blurRadius: 30.0,
                                spreadRadius: -4.0,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 9,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // main
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/rides_img.jpg',
                                          width: 45,
                                          height: 45,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15.w),
                                    Flexible(
                                      flex: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '124 Nicholson dr to Heritage drive',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      255, 85, 0, 0.14),
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                child: Text(
                                                  'In-House Driver',
                                                  style: GoogleFonts.poppins(
                                                      color: backgroundColor,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 6.w,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      17, 205, 1, .15),
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                child: Text(
                                                  'Completed',
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(
                                                          0xff11CD01),
                                                      fontSize: 8,
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
                                            '34 minutes ago',
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
                              ),
                              const Flexible(
                                flex: 2,
                                child: Icon(
                                  Icons.more_horiz,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: page,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(9, 39, 127, .15),
                                blurRadius: 30.0,
                                spreadRadius: -4.0,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 9,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // main
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/rides_img.jpg',
                                          width: 45,
                                          height: 45,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15.w),
                                    Flexible(
                                      flex: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '124 Nicholson dr to Heritage drive',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      255, 85, 0, 0.14),
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                child: Text(
                                                  'In-House Driver',
                                                  style: GoogleFonts.poppins(
                                                      color: backgroundColor,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 6.w,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      17, 205, 1, .15),
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                child: Text(
                                                  'Completed',
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(
                                                          0xff11CD01),
                                                      fontSize: 8,
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
                                            '34 minutes ago',
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
                              ),
                              const Flexible(
                                flex: 2,
                                child: Icon(
                                  Icons.more_horiz,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: page,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(9, 39, 127, .15),
                                blurRadius: 30.0,
                                spreadRadius: -4.0,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 9,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // main
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/rides_img.jpg',
                                          width: 45,
                                          height: 45,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15.w),
                                    Flexible(
                                      flex: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '124 Nicholson dr to Heritage drive',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      255, 85, 0, 0.14),
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                child: Text(
                                                  'In-House Driver',
                                                  style: GoogleFonts.poppins(
                                                      color: backgroundColor,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 6.w,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      17, 205, 1, .15),
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                child: Text(
                                                  'Completed',
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(
                                                          0xff11CD01),
                                                      fontSize: 8,
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
                                            '34 minutes ago',
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
                              ),
                              const Flexible(
                                flex: 2,
                                child: Icon(
                                  Icons.more_horiz,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                      ],
                    ),
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
                    Container(
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
                            child: Obx(() {
                              // Observe changes to the user data in UserController
                              var user = Get.find<AuthController>().user.value;
                              // User data is available
                              return Text(
                                (user != null)
                                    ? 'Hello, ${user.email}'
                                    : 'Loading...', // Display user's name
                                style: GoogleFonts.poppins(
                                    color: Colors.white.withOpacity(.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              );
                            }),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: Colors.white.withOpacity(.7),
                          ),
                        ],
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
                Wrap(
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
}
