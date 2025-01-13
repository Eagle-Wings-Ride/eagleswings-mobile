import 'package:eaglerides/presentation/screens/account/about.dart';
import 'package:eaglerides/presentation/screens/account/child_registration.dart';
import 'package:eaglerides/presentation/screens/account/faq.dart';
import 'package:eaglerides/presentation/screens/account/my_information.dart';
import 'package:eaglerides/presentation/screens/account/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthController _authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEFEFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildAppBar(context),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Column(
                children: [
                  _buildTiles(
                    'My Information',
                    Icons.person_outline,
                    const MyInformation(),
                  ),
                  _buildTiles(
                    'Child Registration',
                    Icons.person_outline,
                    const ChildRegistration(),
                  ),
                  _buildTiles(
                    'About Us',
                    Icons.lightbulb_outline_sharp,
                    const AboutUsView(),
                  ),
                  _buildTiles(
                    'Terms & Conditions',
                    Icons.shield_outlined,
                    const TermsAndConditionsView(),
                  ),
                  _buildTiles(
                    'FAQ',
                    Icons.help_outline_outlined,
                    const FAQ(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      minLeadingWidth: 0,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () async {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AlertDialog.adaptive(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        30, 10, 30, 20),
                                    elevation: 0,
                                    alignment: Alignment.bottomCenter,
                                    insetPadding: const EdgeInsets.all(0),
                                    scrollable: true,
                                    title: null,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    content: SizedBox(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 15),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Text(
                                                        'Confirm Log Out',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.nunito(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: Column(
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            minimumSize:
                                                                const Size(
                                                                    400, 50),
                                                            backgroundColor:
                                                                backgroundColor,
                                                            elevation: 0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                88,
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            // await GlobalService
                                                            //     .sharedPreferencesManager
                                                            //     .logOut(
                                                            //         context);
                                                            _authController
                                                                .logout(
                                                                    context);
                                                          },
                                                          child: Text(
                                                            'Confirm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 30),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              'Cancel',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .nunito(
                                                                color:
                                                                    backgroundColor,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
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
                                    ),
                                  )
                                ],
                              );
                            });
                        // SystemNavigator.pop();
                        // await GlobalService.sharedPreferencesManager
                        //     .logOut(context);
                        // Navigator.pushNamed(context, RouteList.profile);
                      },
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
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

  Padding _buildTiles(String text, IconData icon, Widget widget) {
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
        onTap: () {
          Get.to(widget);
          // Navigator.pushNamed(context, my_information);
        },
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
      ),
    );
  }

  Container buildAppBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        color: backgroundColor,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                Image.asset(
                  'assets/images/app_name_white.png',
                  height: 12,
                  width: 48,
                ),
                const SizedBox(
                  height: 25,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Help',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(() {
                  var user = Get.find<AuthController>().user.value;
                  return Text(
                    (user != null) ? 'Hello, ${user.email}' : 'Loading...',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
