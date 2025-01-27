import 'package:flutter/material.dart';

Color getStatusColor(String? status) {
  switch (status) {
    case 'completed':
      return const Color(0xff11CD01); // Green for booked
    case 'cancelled':
      return const Color(0xffFF4D4D); // Red for canceled
    case 'booked':
      return const Color(0xff4D79FF); // Blue for completed
    case 'ongoing':
      return const Color(0xffFFC107); // Yellow for ongoing
    default:
      return const Color(0xffB0BEC5); // Grey for unknown statuses
  }
}


Color getStatusTextColor(String? status) {
  switch (status) {
    case 'completed':
      return const Color(0xff11CD01); // Green
    case 'ppcoming':
      return const Color(0xffFF5500); // Orange
    case 'in progress':
      return const Color(0xff007BFF); // Blue
    case 'cancelled':
      return const Color(0xffFF0000); // Red
    default:
      return Colors.black; // Default text color
  }
}

Color getRideTypeColor(String? rideType) {
  switch (rideType) {
    case 'In-House':
      return const Color(0xffFF5500); // Orange for In-House
    case 'in-house driver':
      return const Color(0xffFF5500); // Orange for In-House
    case 'freelance driver':
      return const Color(0xff133BB7); // Blue for Freelance
    case 'freelance':
      return const Color(0xff133BB7); // Blue for Freelance
    default:
      return const Color(0xffB0BEC5); // Grey for unknown ride types
  }
}
