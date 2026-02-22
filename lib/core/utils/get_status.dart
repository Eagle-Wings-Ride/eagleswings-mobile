import 'package:flutter/material.dart';

Color getStatusColor(String? status) {
  switch (status) {
    case 'completed':
      return const Color(0xff11CD01); // Green for booked
    case 'cancelled':
      return const Color(0xffFF4D4D); // Red for canceled
    case 'booked':
      return const Color(0xff4D79FF); // Blue for completed
    case 'paid':
      return const Color(0xff0E9F6E); // Green for paid
    case 'assigned':
      return const Color(0xff2F80ED); // Blue for assigned
    case 'ongoing':
      return const Color(0xffFFC107); // Yellow for ongoing
    case 'payment_failed':
      return const Color(0xffD92D20); // Red for failed payments
    case 'expired':
      return const Color(0xffF79009); // Amber for expired rides
    default:
      return const Color(0xffB0BEC5); // Grey for unknown statuses
  }
}

Color getStatusTextColor(String? status) {
  switch (status) {
    case 'completed':
      return const Color(0xff11CD01); // Green
    case 'upcoming':
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
    case 'inhouse':
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

Color getRideTypeTextColor(String? rideType) {
  switch (rideType) {
    case 'In-House':
      return const Color.fromRGBO(255, 85, 0, .14); // Orange for In-House
    case 'inhouse':
      return const Color.fromRGBO(255, 85, 0, .14); // Orange for In-House
    case 'in-house driver':
      return const Color.fromRGBO(255, 85, 0, .14); // Orange for In-House
    case 'freelance driver':
      return const Color(0xff133BB7); // Blue for Freelance
    case 'freelance':
      return const Color(0xff133BB7); // Blue for Freelance
    default:
      return const Color(0xffB0BEC5); // Grey for unknown ride types
  }
}
