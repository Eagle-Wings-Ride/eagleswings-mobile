import 'package:eaglerides/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// import '../../../core/core.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: page,
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
          'FAQ',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/app_logo.png',
                  height: 100.h,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 29.h),
                  child: Text(
                    'Find the most asked questions and their answers right here',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare'
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        )),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    tilePadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    collapsedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    children: [
                      Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare'
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        )),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    tilePadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    collapsedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    children: [
                      Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare'
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        )),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    tilePadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    collapsedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    expandedAlignment: Alignment.topLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare'
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        )),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    tilePadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    collapsedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    expandedAlignment: Alignment.topLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare'
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        )),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    tilePadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    collapsedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    expandedAlignment: Alignment.topLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare'
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        )),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    tilePadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    collapsedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    expandedAlignment: Alignment.topLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      'Lorem ipsum dolor sit amet consectetur. Ornare'
                          .toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    tilePadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    collapsedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    expandedAlignment: Alignment.topLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare'
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        )),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    tilePadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    collapsedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    expandedAlignment: Alignment.topLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare'
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        )),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    tilePadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    collapsedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    expandedAlignment: Alignment.topLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                        'Lorem ipsum dolor sit amet consectetur. Ornare'
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        )),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    tilePadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    collapsedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    expandedAlignment: Alignment.topLeft,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare Lorem ipsum dolor sit amet consectetur. Ornare",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
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
