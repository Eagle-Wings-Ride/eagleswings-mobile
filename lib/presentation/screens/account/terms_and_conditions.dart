import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({super.key});

  @override
  State<TermsAndConditionsView> createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Terms & Condition',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: 10.h, left: 16.w, right: 16.w, bottom: 32.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: EdgeInsets.only(bottom: 29.h),
                //   child: Text(
                //     "TAA Connect Logistics aims to establish a collaborative, secure, and mutually beneficial environment for Users/Customers and Riders, so we have come up with a Terms and Conditions a Rider and Users/Customers must adhere to in other to promote peace and tranquility. \n \n This Terms and Conditions will serve as the foundation for a fair and secure environment for both Riders and Users/Customers: ",
                //     textAlign: TextAlign.center,
                //     style: GoogleFonts.nunito(
                //       fontSize: 15.sp,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Code of Conduct: ',
                      style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada.  ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 40.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. Payment and Rewards: ',
                      style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada.  ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada.  ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 40.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3. Liability and Insurance: ',
                      style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 40.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4. Data Privacy: ',
                      style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada.  ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 40.h),
                      child: Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ",
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '5. Delivery Policy: ',
                      style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada.  ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      child: Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ",
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      child: Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ",
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 40.h),
                      child: Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada.  ",
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '6. Safety Policy: ',
                      style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada.  ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 40.h),
                      child: Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada.  ",
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '7. Speed Limit Policy: ',
                      style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada.  ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 40.h),
                      child: Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ",
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '8. Termination Policy: ',
                      style: GoogleFonts.nunito(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada.  ',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada. ",
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 40.h),
                      child: Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada.  ",
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 29.h),
                  child: Text(
                    "Lorem ipsum dolor sit amet consectetur. Ornare adipiscing sit aliquam cras eleifend imperdiet commodo sit malesuada.  ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
