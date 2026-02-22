import 'package:eaglerides/presentation/controller/auth/auth_controller.dart';
import 'package:eaglerides/presentation/screens/account/account.dart';
import 'package:eaglerides/presentation/screens/home/home.dart';
import 'package:eaglerides/presentation/screens/ride/rides_screen.dart';
import 'package:eaglerides/presentation/screens/ride/trip_history_screen.dart'; // ⭐ ADD THIS
import 'package:eaglerides/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../injection_container.dart' as di;
import 'package:iconsax/iconsax.dart';

import 'data/core/api_client.dart';

class NavigationPage extends StatefulWidget {
  final int initialTab;

  const NavigationPage({super.key, this.initialTab = 0});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final AuthController _authController = Get.put(di.sl<AuthController>());

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialTab;
    _loadUserAndSetToken();
  }

  Future<void> _loadUserAndSetToken() async {
    try {
      await _authController.loadUser();
      await _authController.fetchChildren();
      await _authController.fetchRatesData();

      final token = await _authController.getToken();

      if (token != null) {
        final apiClient = di.sl<ApiClient>();
        apiClient.setToken(token);
        print('Token set: $token');
      }
    } catch (e) {
      print('Error loading user or setting token: $e');
    }
  }

  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildPage(currentIndex),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        height: (MediaQuery.of(context).size.height >= 1000) ? 70 : 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(9, 39, 127, .15),
              blurRadius: 30.0,
              spreadRadius: -4.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            // ⭐ CHANGED FROM 3 TO 4
            return InkWell(
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    margin: EdgeInsets.only(
                      bottom: index == currentIndex
                          ? 0
                          : MediaQuery.of(context).size.width * .029,
                    ),
                    width: MediaQuery.of(context).size.width * .168,
                    height: index == currentIndex
                        ? MediaQuery.of(context).size.width * .014
                        : 0,
                  ),
                  Icon(
                    listOfIcons[index],
                    size: 20,
                    color: index == currentIndex ? backgroundColor : textColor,
                  ),
                  Text(
                    navText[index],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color:
                          index == currentIndex ? backgroundColor : Colors.grey,
                      fontWeight: index == currentIndex
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // ⭐ UPDATED: Added "History" tab
  List<String> navText = [
    'Home',
    'Ride',
    'History', // ⭐ NEW
    'Account',
  ];

  // ⭐ UPDATED: Added history icon
  List<IconData> listOfIcons = [
    Iconsax.home,
    Iconsax.car,
    Iconsax.clock, // ⭐ NEW - or use Iconsax.document
    Iconsax.profile_circle,
  ];

  // ⭐ UPDATED: Added trip history case
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const RidesScreen();
      case 2:
        return const TripHistoryScreen(); // ⭐ NEW
      case 3:
        return const AccountScreen();
      default:
        return const HomePage();
    }
  }
}
