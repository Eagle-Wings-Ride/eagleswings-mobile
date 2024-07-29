import 'package:eaglerides/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: page,
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
                      quickButtons('check_rates', 'Check rates'),
                      quickButtons('book_rides', 'Book rides'),
                      quickButtons('track_rides', 'Track rides'),
                      quickButtons('history', 'History'),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current Rides',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              'View all',
                              style: GoogleFonts.dmSans(
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
          style: GoogleFonts.dmSans(
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
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Container(
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
                      SizedBox(
                        width: 16.w,
                      ),
                      Text(
                        '102 Fox drive, Dominion Road. T9H3V2',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
                            child: Text(
                              'Timmy Spark',
                              style: GoogleFonts.dmSans(
                                  color: Colors.white.withOpacity(.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(148, 163, 208, 0.2),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.white.withOpacity(.7),
                        size: 16,
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
                  style: GoogleFonts.dmSans(
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
                      style: GoogleFonts.dmSans(
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
