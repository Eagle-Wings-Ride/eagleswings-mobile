import 'package:eaglerides/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({super.key});

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/app_name.png',
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 29.h, top: 30),
                  child: Text(
                    'About Us',
                    style: GoogleFonts.poppins(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Image.asset(
                    'assets/images/about_image.png',
                    // height: 80.h,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                // Text(
                //   'Our Goal',
                //   style: GoogleFonts.poppins(
                //     fontSize: 20.sp,
                //     fontWeight: FontWeight.w700,
                //     color: Colors.black,
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Text(
                    "Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. Ut semper nisl mattis viverra egestas hac massa adipiscing. Imperdiet eleifend augue ante sed mi arcu lectus. Ullamcorper ante enim sit tristique eu. Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. Ut semper nisl mattis viverra egestas hac massa adipiscing. Imperdiet eleifend augue ante sed mi arcu lectus. Ullamcorper ante enim sit tristique eu.",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 20.h,
                // ),
                // Text(
                //   'Our Mission',
                //   style: GoogleFonts.poppins(
                //     fontSize: 20.sp,
                //     fontWeight: FontWeight.w700,
                //     color: Colors.black,
                //   ),
                // ),
                // Text(
                //   "Our mission is to improve on the existing system by leveraging on cutting-edge technology, skilled and trained riders to ensure that customers package is delivered safely, securely and timely. ",
                //   style: GoogleFonts.poppins(
                //     fontSize: 16.sp,
                //     fontWeight: FontWeight.w500,
                //     color: Colors.grey,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
