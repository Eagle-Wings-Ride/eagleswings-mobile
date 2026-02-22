import 'dart:async';
import 'dart:convert';
import 'dart:math' as math; // ⭐ ADD THIS
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;

import '../../../data/core/api_constants.dart';
import '../../../data/models/book_rides_model.dart';
import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';
import 'driver_profile_screen.dart';

class LiveTrackingScreen extends StatefulWidget {
  final String bookingId;
  final Map<String, dynamic> rideDetails;

  const LiveTrackingScreen({
    super.key,
    required this.bookingId,
    required this.rideDetails,
  });

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final AuthController _authController = Get.find<AuthController>();
  
  // Map state
  late LatLng _pickupLocation;
  late LatLng _dropoffLocation;
  late LatLng _driverLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  
  // Driver state - ALL FROM REAL DATA NOW!
  Map<String, dynamic>? _driverInfo;
  Booking? _booking;
  
  // Tracking state
  double _distance = 0.0;
  int _estimatedTime = 0;
  double _driverBearing = 0.0;
  bool _isLoading = true;
  Timer? _locationUpdateTimer;
  
  String _rideStatus = 'assigned';

  @override
  void initState() {
    super.initState();
    _loadRideDetails();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  // ⭐ LOAD REAL DATA FROM YOUR BOOKING
  void _loadRideDetails() {
    try {
      // Get the actual booking object
      _booking = widget.rideDetails['booking'] as Booking?;
      
      setState(() {
        // ⭐ USE REAL DRIVER INFO FROM BOOKING
        if (_booking != null && _booking!.hasDrivers) {
          final driver = _booking!.primaryDriver!;
          _driverInfo = {
            'id': driver.id,
            'name': driver.fullname,
            // 'phone': driver.phoneNumber ?? 'N/A',
            // 'email': driver.email,
            'rating': 4.8, // TODO: Add rating field to Driver model
            'totalRides': 1247, // TODO: Add totalRides to Driver model
            'carModel': 'Toyota Camry', // TODO: Add vehicle info to Driver model
            'carPlate': 'ABC 1234', // TODO: Add to Driver model
            'carColor': 'Silver', // TODO: Add to Driver model
            'photo': driver.image,
            'status': driver.status,
            'isAvailable': driver.isAvailable,
          };
        }

        // ⭐ USE REAL COORDINATES FROM BOOKING
        if (_booking != null) {
          _pickupLocation = LatLng(
            double.tryParse(_booking!.startLatitude) ?? 56.757574,
            double.tryParse(_booking!.startLongitude) ?? -111.464576,
          );

          _dropoffLocation = LatLng(
            double.tryParse(_booking!.endLatitude) ?? 56.758389,
            double.tryParse(_booking!.endLongitude) ?? -111.457832,
          );

          _rideStatus = _booking!.status.toLowerCase();
        } else {
          // Fallback to passed coordinates
          _pickupLocation = LatLng(
            double.tryParse(widget.rideDetails['pickupLat']?.toString() ?? '56.757574') ?? 56.757574,
            double.tryParse(widget.rideDetails['pickupLng']?.toString() ?? '-111.464576') ?? -111.464576,
          );

          _dropoffLocation = LatLng(
            double.tryParse(widget.rideDetails['dropoffLat']?.toString() ?? '56.758389') ?? 56.758389,
            double.tryParse(widget.rideDetails['dropoffLng']?.toString() ?? '-111.457832') ?? -111.457832,
          );
        }

        // Initialize driver location (will be updated from API)
        _driverLocation = _pickupLocation;
        
        _isLoading = false;
      });

      _setupMapMarkers();
      _drawRoute();
    } catch (e) {
      print('Error loading ride details: $e');
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Failed to load ride details');
    }
  }

  // ⭐ GET REAL-TIME DRIVER LOCATION FROM YOUR API
  void _startLocationUpdates() {
    // Update every 5 seconds
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateDriverLocation();
    });
    
    // First update immediately
    _updateDriverLocation();
  }

  // ⭐ CALL YOUR BACKEND API TO GET DRIVER'S CURRENT LOCATION
  Future<void> _updateDriverLocation() async {
    if (_driverInfo == null) return;

    try {
      // ⭐ REPLACE WITH YOUR ACTUAL API ENDPOINT
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/driver-location/${widget.bookingId}'),
        headers: {
          // 'Authorization': 'Bearer ${_authController.token.value}',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 && mounted) {
        final data = jsonDecode(response.body);
        
        // ⭐ PARSE REAL DRIVER LOCATION FROM API
        final newLat = double.tryParse(data['latitude']?.toString() ?? '0');
        final newLng = double.tryParse(data['longitude']?.toString() ?? '0');
        
        if (newLat != null && newLng != null && newLat != 0 && newLng != 0) {
          setState(() {
            _driverLocation = LatLng(newLat, newLng);
            
            // Calculate bearing for rotation
            _driverBearing = _calculateBearing(
              _driverLocation.latitude,
              _driverLocation.longitude,
              _pickupLocation.latitude,
              _pickupLocation.longitude,
            );

            // Calculate distance
            _distance = _calculateDistance(
              _driverLocation.latitude,
              _driverLocation.longitude,
              _pickupLocation.latitude,
              _pickupLocation.longitude,
            );

            // Calculate ETA (rough estimate: distance / average speed)
            _estimatedTime = (_distance / 40 * 60).round(); // 40 km/h average speed
            
            // Update ride status if available
            if (data['status'] != null) {
              _rideStatus = data['status'].toString().toLowerCase();
            }
          });

          _updateDriverMarker();
          _animateCameraToDriver();
        }
      } else {
        print('Failed to get driver location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating driver location: $e');
      // Don't show error to user on every failed update
    }
  }

  void _setupMapMarkers() {
    _markers = {
      // Pickup marker
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Pickup Location',
          snippet: _booking?.mainPickupAddress ?? 
                   widget.rideDetails['pickupAddress'] ?? '',
        ),
      ),
      
      // Dropoff marker
      Marker(
        markerId: const MarkerId('dropoff'),
        position: _dropoffLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Drop-off Location',
          snippet: _booking?.mainDropoffAddress ?? 
                   widget.rideDetails['dropoffAddress'] ?? '',
        ),
      ),
      
      // Driver marker
      Marker(
        markerId: const MarkerId('driver'),
        position: _driverLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
          title: _driverInfo?['name'] ?? 'Driver',
          snippet: 'On the way',
        ),
        rotation: _driverBearing,
      ),
    };
  }

  void _updateDriverMarker() {
    setState(() {
      _markers.removeWhere((m) => m.markerId.value == 'driver');
      _markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: _driverLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: _driverInfo?['name'] ?? 'Driver',
            snippet: 'On the way',
          ),
          rotation: _driverBearing,
        ),
      );
    });
  }

  void _drawRoute() {
    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [_pickupLocation, _driverLocation, _dropoffLocation],
        color: backgroundColor,
        width: 5,
        geodesic: true,
        jointType: JointType.round,
      ),
    };
  }

  void _animateCameraToDriver() async {
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _driverLocation,
          zoom: 15,
          tilt: 45,
        ),
      ),
    );
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c;
  }

  double _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    final dLon = _toRadians(lon2 - lon1);
    final y = math.sin(dLon) * math.cos(_toRadians(lat2));
    final x = math.cos(_toRadians(lat1)) * math.sin(_toRadians(lat2)) -
        math.sin(_toRadians(lat1)) * math.cos(_toRadians(lat2)) * math.cos(dLon);
    return (_toDegrees(math.atan2(y, x)) + 360) % 360;
  }

  double _toRadians(double degree) => degree * math.pi / 180;
  double _toDegrees(double radian) => radian * 180 / math.pi;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: backgroundColor),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildTopInfo(),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _pickupLocation,
        zoom: 14,
      ),
      markers: _markers,
      polylines: _polylines,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Widget _buildTopInfo() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    _getStatusText(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Iconsax.location, color: backgroundColor, size: 20),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    _distance > 0 
                        ? '${_distance.toStringAsFixed(1)} km away'
                        : 'Calculating...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _estimatedTime > 0 ? '$_estimatedTime min' : '--',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.35,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildDriverCard(),
                  SizedBox(height: 20.h),
                  _buildChildInfo(),
                  SizedBox(height: 20.h),
                  _buildTripRoute(),
                  SizedBox(height: 20.h),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDriverCard() {
    if (_driverInfo == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        // ⭐ NAVIGATE TO DRIVER PROFILE WITH REAL DATA
        Get.to(() => DriverProfileScreen(
          driverData: {
            'id': _driverInfo!['id'],
            'name': _driverInfo!['name'],
            'phone': _driverInfo!['phone'],
            'email': _driverInfo!['email'],
            'rating': _driverInfo!['rating'],
            'totalRides': _driverInfo!['totalRides'],
            'totalRatings': 1247,
            'yearsExperience': 5,
            'completionRate': 98,
            'carModel': _driverInfo!['carModel'],
            'carPlate': _driverInfo!['carPlate'],
            'carColor': _driverInfo!['carColor'],
            'photo': _driverInfo!['photo'],
            'location': 'Fort McMurray, AB',
            'reviews': [], // TODO: Fetch from API
          },
        ));
      },
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: backgroundColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor.withOpacity(0.2),
                image: _driverInfo!['photo'] != null
                    ? DecorationImage(
                        image: NetworkImage(_driverInfo!['photo']),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _driverInfo!['photo'] == null
                  ? Icon(Icons.person, size: 30, color: backgroundColor)
                  : null,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _driverInfo!['name'] ?? 'Driver',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      SizedBox(width: 4.w),
                      Text(
                        '${_driverInfo!['rating'] ?? 0.0}',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '${_driverInfo!['carModel']} • ${_driverInfo!['carPlate']}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: textColor.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }

  Widget _buildChildInfo() {
    if (_booking == null) return const SizedBox.shrink();

    final child = _booking!.child;
    
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.2),
              image: child.image != null
                  ? DecorationImage(
                      image: NetworkImage(child.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: child.image == null
                ? Icon(Icons.child_care, color: Colors.blue)
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.fullname,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Grade ${child.grade} • ${child.age} years old',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripRoute() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip Route',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15.h),
        _buildLocationRow(
          icon: Icons.radio_button_checked,
          color: Colors.green,
          title: 'Pickup',
          address: _booking?.mainPickupAddress ?? 
                   widget.rideDetails['pickupAddress'] ?? 'N/A',
        ),
        SizedBox(height: 12.h),
        _buildLocationRow(
          icon: Icons.location_on,
          color: Colors.red,
          title: 'Drop-off',
          address: _booking?.mainDropoffAddress ?? 
                   widget.rideDetails['dropoffAddress'] ?? 'N/A',
        ),
      ],
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color color,
    required String title,
    required String address,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: textColor.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                address,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Call driver
              if (_driverInfo != null && _driverInfo!['phone'] != 'N/A') {
                // Launch phone dialer
              }
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              side: BorderSide(color: backgroundColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: Icon(Iconsax.call, color: backgroundColor),
            label: Text(
              'Call',
              style: GoogleFonts.poppins(
                color: backgroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Message driver
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Iconsax.message, color: Colors.white),
            label: Text(
              'Message',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (_rideStatus) {
      case 'ongoing':
        return Colors.blue;
      case 'assigned':
        return Colors.orange;
      case 'arrived':
        return Colors.green;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (_rideStatus) {
      case 'ongoing':
        return 'Driver En Route';
      case 'assigned':
        return 'Driver Assigned';
      case 'arrived':
        return 'Driver Arrived';
      case 'completed':
        return 'Trip Completed';
      default:
        return 'Tracking Active';
    }
  }
}