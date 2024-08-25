import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../styles/styles.dart';

class BookRide extends StatefulWidget {
  const BookRide({super.key});

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Book a Ride',
          style: GoogleFonts.dmSans(fontSize: 25, fontWeight: FontWeight.bold),
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
                            for (var i = 0; i < 15; i++)
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
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                TextFormField(
                                  // autovalidateMode: autoValidateMode,
                                  // onTap: onTap,
                                  autofocus: true,
                                  enableSuggestions: true,
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  cursorHeight: 12,
                                  // controller: controller,
                                  cursorColor:
                                      Theme.of(context).colorScheme.primary,

                                  enableInteractiveSelection: false,
                                  style: GoogleFonts.lato(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 14),

                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffF7F6F6),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Color(0xff616161),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: textColor, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Color(0xff616161),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                    ),
                                    hintText: 'Please enter pick up',
                                    errorStyle: GoogleFonts.lato(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hintStyle: GoogleFonts.lato(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    // errorText: errorText,
                                    suffixIcon: const Icon(
                                      Icons.my_location_outlined,
                                      size: 16,
                                    ),

                                    suffixIconColor: const Color(0xff616161),

                                    contentPadding: EdgeInsets.all(12.sp),
                                  ),
                                  maxLines: 1,

                                  // validator: validator,
                                  //  onChanged: onChanged,
                                ),
                              ],
                            ),
                            for (var i = 0; i < 10; i++)
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
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                TextFormField(
                                  // autovalidateMode: autoValidateMode,
                                  // onTap: onTap,
                                  autofocus: true,
                                  enableSuggestions: true,
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  cursorHeight: 12,
                                  // controller: controller,
                                  cursorColor:
                                      Theme.of(context).colorScheme.primary,

                                  enableInteractiveSelection: false,
                                  style: GoogleFonts.lato(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 14),

                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffF7F6F6),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Color(0xff616161),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: textColor, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Color(0xff616161),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                    ),
                                    hintText: 'Please enter drop off',
                                    errorStyle: GoogleFonts.lato(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hintStyle: GoogleFonts.lato(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    // errorText: errorText,
                                    suffixIcon: const Icon(
                                      Icons.my_location_outlined,
                                      size: 16,
                                    ),

                                    suffixIconColor: const Color(0xff616161),

                                    contentPadding: EdgeInsets.all(12.sp),
                                  ),
                                  maxLines: 1,

                                  // validator: validator,
                                  //  onChanged: onChanged,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
