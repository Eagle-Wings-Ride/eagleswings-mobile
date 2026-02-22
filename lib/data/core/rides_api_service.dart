import 'dart:convert';
import 'package:http/http.dart' as http;

/// API Service for all ride-related operations
class RidesApiService {
  final String baseUrl;
  final String Function() getToken;

  RidesApiService({
    required this.baseUrl,
    required this.getToken,
  });

  /// Get authorization headers
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${getToken()}',
      };

  /// Get all rides for the authenticated user
  /// Endpoint: GET /book/rides/
  Future<Map<String, dynamic>> getRidesByUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/book/rides/'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': _getErrorMessage(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Get all rides for a specific child
  /// Endpoint: GET /book/ride/{childId}
  Future<Map<String, dynamic>> getRidesByChildId(String childId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/book/ride/$childId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data is List ? {'rides': data} : data,
        };
      } else {
        return {
          'success': false,
          'message': _getErrorMessage(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Get recent rides for a specific child
  /// Endpoint: GET /book/rides/recent/{childId}/
  Future<Map<String, dynamic>> getRecentRidesByChild(String childId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/book/rides/recent/$childId/'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': _getErrorMessage(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Get rides by child and status
  /// Endpoint: GET /book/rides/status/{childId}/{status}
  /// Status options: paid, booked, completed, canceled, ongoing
  Future<Map<String, dynamic>> getRidesByStatus(
    String childId,
    String status,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/book/rides/status/$childId/$status'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': _getErrorMessage(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Book a new ride for a child
  /// Endpoint: POST /book/{childId}
  Future<Map<String, dynamic>> bookRide({
    required String childId,
    required Map<String, dynamic> bookingData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/book/$childId'),
        headers: _headers,
        body: json.encode(bookingData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': _getErrorMessage(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Update ride status
  /// Endpoint: PUT /book/rides/status/{bookingId}/
  Future<Map<String, dynamic>> updateRideStatus({
    required String bookingId,
    required String status,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/book/rides/status/$bookingId/'),
        headers: _headers,
        body: json.encode({'status': status}),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': _getErrorMessage(response),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Cancel a ride
  Future<Map<String, dynamic>> cancelRide(String bookingId) async {
    return updateRideStatus(bookingId: bookingId, status: 'cancelled');
  }

  /// Helper method to extract error message from response
  String _getErrorMessage(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['message'] ?? 
             body['error'] ?? 
             'Request failed with status ${response.statusCode}';
    } catch (e) {
      return 'Request failed with status ${response.statusCode}';
    }
  }
}

/// Booking data builder for creating new rides
class BookingDataBuilder {
  String? rideType;
  String? tripType;
  String? scheduleType;
  List<String>? pickupDays;
  String? startDate;
  
  String? morningFrom;
  String? morningTo;
  String? morningTime;
  
  String? afternoonFrom;
  String? afternoonTo;
  String? afternoonTime;
  
  String? startLongitude;
  String? startLatitude;
  String? endLongitude;
  String? endLatitude;

  BookingDataBuilder setRideType(String type) {
    rideType = type;
    return this;
  }

  BookingDataBuilder setTripType(String type) {
    tripType = type;
    return this;
  }

  BookingDataBuilder setScheduleType(String type) {
    scheduleType = type;
    return this;
  }

  BookingDataBuilder setPickupDays(List<String> days) {
    pickupDays = days;
    return this;
  }

  BookingDataBuilder setStartDate(String date) {
    startDate = date;
    return this;
  }

  BookingDataBuilder setMorningTrip({
    required String from,
    required String to,
    required String time,
  }) {
    morningFrom = from;
    morningTo = to;
    morningTime = time;
    return this;
  }

  BookingDataBuilder setAfternoonTrip({
    required String from,
    required String to,
    required String time,
  }) {
    afternoonFrom = from;
    afternoonTo = to;
    afternoonTime = time;
    return this;
  }

  BookingDataBuilder setCoordinates({
    required String startLat,
    required String startLon,
    required String endLat,
    required String endLon,
  }) {
    startLatitude = startLat;
    startLongitude = startLon;
    endLatitude = endLat;
    endLongitude = endLon;
    return this;
  }

  Map<String, dynamic> build() {
    assert(rideType != null, 'Ride type is required');
    assert(tripType != null, 'Trip type is required');
    assert(scheduleType != null, 'Schedule type is required');
    assert(pickupDays != null && pickupDays!.isNotEmpty, 'Pickup days are required');
    assert(startDate != null, 'Start date is required');
    assert(morningFrom != null, 'Morning pickup location is required');
    assert(morningTo != null, 'Morning dropoff location is required');
    assert(morningTime != null, 'Morning time is required');

    final data = {
      'ride_type': rideType,
      'trip_type': tripType,
      'schedule_type': scheduleType,
      'pickup_days': pickupDays,
      'start_date': startDate,
      'morning_from': morningFrom,
      'morning_to': morningTo,
      'morning_time': morningTime,
      'start_longitude': startLongitude,
      'start_latitude': startLatitude,
      'end_longitude': endLongitude,
      'end_latitude': endLatitude,
    };

    // Add afternoon trip if it's a return trip
    if (tripType == 'return') {
      assert(afternoonFrom != null, 'Afternoon pickup location required for return trip');
      assert(afternoonTo != null, 'Afternoon dropoff location required for return trip');
      assert(afternoonTime != null, 'Afternoon time required for return trip');
      
      data['afternoon_from'] = afternoonFrom;
      data['afternoon_to'] = afternoonTo;
      data['afternoon_time'] = afternoonTime;
    }

    return data;
  }
}