import 'package:eaglerides/pages/onTripPage/booking_confirmation.dart';
// import 'package:eaglerides/pages/onTripPage/invoice.dart';
// import 'package:eaglerides/pages/onTripPage/map_page.dart';
import 'package:eaglerides/presentation/screens/home/home.dart';
import 'package:eaglerides/presentation/screens/ride/rides_screen.dart';
// import 'package:eaglerides/presentation/screens/ride/map_with_source_destination_field.dart';
import 'package:eaglerides/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  // static const CameraPosition _defaultLocation = CameraPosition(
  //   target: LatLng(23.030357, 72.517845),
  //   zoom: 14.4746,
  // );
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
        height: (MediaQuery.of(context).size.height >= 1000) ? 140 : 90,
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
          children: List.generate(3, (index) {
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
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color:
                          index == currentIndex ? backgroundColor : Colors.grey,
                      fontWeight: index == currentIndex
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * .03),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  List<String> navText = [
    'Home',
    'Ride',
    'Account',
  ];

  List<IconData> listOfIcons = [
    Iconsax.home,
    Iconsax.car,
    Iconsax.profile_circle,
  ];

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const RidesScreen();
      case 2:
        return const HomePage();
      default:
        return const HomePage();
    }
  }
}
