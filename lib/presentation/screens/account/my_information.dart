import 'package:eaglerides/presentation/screens/account/registered_children.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/auth/auth_controller.dart';

class MyInformation extends StatefulWidget {
  const MyInformation({super.key});

  @override
  State<MyInformation> createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'My Information',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios_sharp,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        // Observe changes to the user data in UserController
        var user = Get.find<AuthController>().user.value;
        return Padding(
          padding: const EdgeInsets.only(
            top: 0,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              _buildTiles(
                (user != null) ? user.email.capitalizeFirst! : 'Loading...',
                Icons.person_outline,
                null,
                false,
              ),
              _buildTiles(
                (user != null) ? user.email.capitalizeFirst! : 'Loading...',
                Icons.mail_outline_outlined,
                null,
                false,
              ),
              _buildTiles(
                'Registered Children',
                Icons.person_outline,
                const RegisteredChildren(),
                true,
              ),
            ],
          ),
        );
      }),
    );
  }

  Padding _buildTiles(String text, IconData icon, widget, bool hasTrailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        minLeadingWidth: 0,
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        onTap: hasTrailing
            ? () {
                Get.to(widget);
                // Navigator.pushNamed(context, my_information);
              }
            : null,
        trailing: hasTrailing
            ? const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              )
            : null,
      ),
    );
  }
}
