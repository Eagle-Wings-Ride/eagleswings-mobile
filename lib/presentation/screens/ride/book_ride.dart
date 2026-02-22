import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../data/models/location_onboarding_data.dart';
import '../../../injection_container.dart' as di;
import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';
import '../../controller/ride/ride_controller.dart';
import '../account/child_registration.dart';
import 'address_search_screen.dart';
import 'confirm_booking.dart';

class BookRide extends StatefulWidget {
  const BookRide({super.key});

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  final AuthController _authController = Get.find();
  final RideController _rideController = Get.put(di.sl<RideController>());

  // Controllers
  final TextEditingController _morningPickupController =
      TextEditingController();
  final TextEditingController _morningDropoffController =
      TextEditingController();
  final TextEditingController _afternoonPickupController =
      TextEditingController();
  final TextEditingController _afternoonDropoffController =
      TextEditingController();
  final TextEditingController _childController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _morningTimeController = TextEditingController();
  final TextEditingController _afternoonTimeController =
      TextEditingController();

  // Current step
  int _currentStep = 0;

  // Selections
  String? _selectedChildId;
  String? _selectedChildName;
  String? _selectedDriverType;
  String? _selectedTripType;
  String? _selectedScheduleType;
  List<String> _selectedDays = [];

  // Coordinates
  double? _morningPickupLat, _morningPickupLng;
  double? _morningDropoffLat, _morningDropoffLng;
  double? _afternoonPickupLat, _afternoonPickupLng;
  double? _afternoonDropoffLat, _afternoonDropoffLng;

  // Calculated values
  double? _estimatedPrice;
  int? _numberOfDays;

  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserAddress();
  }

  void _loadUserAddress() {
    final user = _authController.user.value;
    if (user != null && user.address != null && user.address.isNotEmpty) {
      _morningPickupController.text = user.address;
    }
  }

  @override
  void dispose() {
    _morningPickupController.dispose();
    _morningDropoffController.dispose();
    _afternoonPickupController.dispose();
    _afternoonDropoffController.dispose();
    _childController.dispose();
    _startDateController.dispose();
    _morningTimeController.dispose();
    _afternoonTimeController.dispose();
    super.dispose();
  }

  // Calculate price based on selections
  void _calculatePrice() {
    if (_selectedDriverType == null ||
        _selectedTripType == null ||
        _selectedScheduleType == null) {
      return;
    }

    final rates = _authController.rates.value;
    if (rates == null) return;

    String driverKey = _selectedDriverType == 'inhouse'
        ? 'in_house_drivers'
        : 'freelance_drivers';
    String scheduleKey = _selectedScheduleType == '2 weeks'
        ? 'bi_weekly'
        : _selectedScheduleType == '1 month'
            ? 'monthly'
            : 'daily';
    String tripKey = _selectedTripType == 'return' ? 'return' : 'one_way';

    try {
      final price = rates[driverKey]?[scheduleKey]?[tripKey];
      if (mounted) {
        setState(() {
          _estimatedPrice = price?.toDouble() ?? 0.0;
        });
      }
    } catch (e) {
      print('Error calculating price: $e');
    }
  }

  // Calculate number of days
  void _calculateNumberOfDays() {
    if (_startDateController.text.isEmpty || _selectedScheduleType == null) {
      return;
    }

    int days = 0;

    switch (_selectedScheduleType) {
      case '2 weeks':
        days = 14;
        break;
      case '1 month':
        days = 30;
        break;
      default:
        days = _selectedDays.length;
    }

    if (mounted) {
      setState(() {
        _numberOfDays = days;
      });
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      return DateFormat('d MMMM, yyyy').parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                _buildStep1ChildSelection(),
                _buildStep2TripDetails(),
                _buildStep3LocationDetails(),
                _buildStep4Schedule(),
                _buildStep5Review(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep--);
                } else {
                  Get.back();
                }
              },
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Text(
              'Book a Ride',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            if (_estimatedPrice != null && _estimatedPrice! > 0)
              Padding(
                padding: EdgeInsets.only(top: 20.h, right: 16.w),
                child: Center(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '\$${_estimatedPrice!.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(5, (index) {
          bool isActive = index == _currentStep;
          bool isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: isActive ? 6 : 4,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? backgroundColor
                          : isActive
                              ? backgroundColor
                              : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: backgroundColor.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                  ),
                ),
                if (index < 4) SizedBox(width: 8.w),
              ],
            ),
          );
        }),
      ),
    );
  }

  // STEP 1: Child Selection
  Widget _buildStep1ChildSelection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Who\'s riding today?',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            'Select the child for this ride',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: textColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 30.h),
          Obx(() {
            if (_authController.children.isEmpty) {
              return _buildNoChildrenCard();
            }
            return Column(
              children: _authController.children.map((child) {
                bool isSelected = _selectedChildId == child.id;
                return _buildChildCard(child, isSelected);
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChildCard(child, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChildId = child.id;
          _selectedChildName = child.fullname;
          _childController.text = child.fullname;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: isSelected ? backgroundColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? backgroundColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor.withOpacity(0.2),
                image: child.image != null && child.image!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(child.image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: child.image == null || child.image!.isEmpty
                  ? Center(
                      child: Text(
                        child.fullname.isNotEmpty
                            ? child.fullname[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: backgroundColor,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.fullname ?? 'Unknown',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    '${child.age ?? 0} years • Grade ${child.grade ?? 'N/A'} • ${child.school ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: backgroundColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoChildrenCard() {
    return Container(
      padding: EdgeInsets.all(30.sp),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: backgroundColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(Iconsax.profile_2user, size: 60, color: backgroundColor),
          SizedBox(height: 20.h),
          Text(
            'No Children Found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'You need to add a child profile before booking a ride',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: textColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: () => Get.to(() => const ChildRegistration()),
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              'Add Child',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // STEP 2: Trip Details
  Widget _buildStep2TripDetails() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Details',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            'Configure your ride preferences',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: textColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 30.h),

          // Driver Type
          _buildSectionTitle('Driver Type'),
          Row(
            children: [
              Expanded(
                child: _buildOptionCard(
                  title: 'In-House',
                  subtitle: 'Company drivers',
                  icon: Iconsax.user,
                  isSelected: _selectedDriverType == 'inhouse',
                  onTap: () {
                    setState(() => _selectedDriverType = 'inhouse');
                    _calculatePrice();
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildOptionCard(
                  title: 'Freelance',
                  subtitle: 'Independent',
                  icon: Iconsax.car,
                  isSelected: _selectedDriverType == 'freelance',
                  onTap: () {
                    setState(() => _selectedDriverType = 'freelance');
                    _calculatePrice();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),

          // Trip Type
          _buildSectionTitle('Trip Type'),
          Row(
            children: [
              Expanded(
                child: _buildOptionCard(
                  title: 'One Way',
                  subtitle: 'Single trip',
                  icon: Iconsax.arrow_right_3,
                  isSelected: _selectedTripType == 'one-way',
                  onTap: () {
                    setState(() => _selectedTripType = 'one-way');
                    _calculatePrice();
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildOptionCard(
                  title: 'Return',
                  subtitle: 'Round trip',
                  icon: Iconsax.repeat,
                  isSelected: _selectedTripType == 'return',
                  onTap: () {
                    setState(() => _selectedTripType = 'return');
                    _calculatePrice();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),

          // Schedule Type
          _buildSectionTitle('Schedule Duration'),
          Column(
            children: [
              _buildOptionCard(
                title: '2 Weeks',
                subtitle: '14 days of service',
                icon: Iconsax.calendar,
                isSelected: _selectedScheduleType == '2 weeks',
                onTap: () {
                  setState(() => _selectedScheduleType = '2 weeks');
                  _calculatePrice();
                  _calculateNumberOfDays();
                },
              ),
              SizedBox(height: 12.h),
              _buildOptionCard(
                title: '1 Month',
                subtitle: '30 days of service',
                icon: Iconsax.calendar_1,
                isSelected: _selectedScheduleType == '1 month',
                onTap: () {
                  setState(() => _selectedScheduleType = '1 month');
                  _calculatePrice();
                  _calculateNumberOfDays();
                },
              ),
            ],
          ),

          if (_estimatedPrice != null && _estimatedPrice! > 0) ...[
            SizedBox(height: 30.h),
            _buildPriceCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceCard() {
    if (_estimatedPrice == null || _estimatedPrice == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated Price',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '\$${_estimatedPrice!.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (_numberOfDays != null && _numberOfDays! > 0) ...[
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duration',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  '$_numberOfDays days',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Per Day',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  '\$${(_estimatedPrice! / _numberOfDays!).toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // STEP 3: Location Details
  Widget _buildStep3LocationDetails() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Locations',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            'Set pickup and drop-off points',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: textColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 30.h),

          // Morning Trip
          _buildSectionTitle('Morning Trip'),
          _buildLocationField(
            controller: _morningPickupController,
            label: 'Pickup Location',
            icon: Icons.radio_button_checked,
            iconColor: Colors.green,
            onTap: () async {
              final result = await Get.to(() => AddressSearchScreen(
                    searchController: _morningPickupController,
                  ));
              if (result != null && result is LocationOnboardingData) {
                debugPrint(
                    'Setting location in BookRide: ${result.latitude}, ${result.longitude}');
                setState(() {
                  _morningPickupLat = result.latitude;
                  _morningPickupLng = result.longitude;
                  _morningPickupController.text = result.address ?? '';
                });
              }
            },
          ),
          SizedBox(height: 15.h),
          _buildLocationField(
            controller: _morningDropoffController,
            label: 'Drop-off Location',
            icon: Icons.location_on,
            iconColor: Colors.red,
            onTap: () async {
              final result = await Get.to(() => AddressSearchScreen(
                    searchController: _morningDropoffController,
                  ));
              if (result != null && result is LocationOnboardingData) {
                debugPrint(
                    'Setting location in BookRide: ${result.latitude}, ${result.longitude}');
                setState(() {
                  _morningDropoffLat = result.latitude;
                  _morningDropoffLng = result.longitude;
                  _morningDropoffController.text = result.address ?? '';
                });
              }
            },
          ),
          SizedBox(height: 15.h),
          _buildTimeField(
            controller: _morningTimeController,
            label: 'Pickup Time',
            icon: Iconsax.clock,
          ),

          // Afternoon Trip (if return)
          if (_selectedTripType == 'return') ...[
            SizedBox(height: 30.h),
            _buildSectionTitle('Afternoon Trip'),
            _buildLocationField(
              controller: _afternoonPickupController,
              label: 'Pickup Location',
              icon: Icons.radio_button_checked,
              iconColor: Colors.blue,
              onTap: () async {
                final result = await Get.to(() => AddressSearchScreen(
                      searchController: _afternoonPickupController,
                    ));
                if (result != null && result is LocationOnboardingData) {
                  setState(() {
                    _afternoonPickupLat = result.latitude;
                    _afternoonPickupLng = result.longitude;
                  });
                }
              },
            ),
            SizedBox(height: 15.h),
            _buildLocationField(
              controller: _afternoonDropoffController,
              label: 'Drop-off Location',
              icon: Icons.location_on,
              iconColor: Colors.orange,
              onTap: () async {
                final result = await Get.to(() => AddressSearchScreen(
                      searchController: _afternoonDropoffController,
                    ));
                if (result != null && result is LocationOnboardingData) {
                  setState(() {
                    _afternoonDropoffLat = result.latitude;
                    _afternoonDropoffLng = result.longitude;
                  });
                }
              },
            ),
            SizedBox(height: 15.h),
            _buildTimeField(
              controller: _afternoonTimeController,
              label: 'Pickup Time',
              icon: Iconsax.clock,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    controller.text.isEmpty ? 'Tap to select' : controller.text,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: controller.text.isEmpty ? Colors.grey : textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() {
            // ⭐ ADD THIS LINE
            controller.text = _formatTime(picked);
          }); // ⭐ ADD THIS LINE
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: backgroundColor, size: 20),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    controller.text.isEmpty ? 'Tap to select' : controller.text,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: controller.text.isEmpty ? Colors.grey : textColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // STEP 4: Schedule
  Widget _buildStep4Schedule() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            'When does the ride start?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: textColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 30.h),

          // Start Date
          _buildSectionTitle('Start Date'),
          GestureDetector(
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
              );
              if (picked != null) {
                _startDateController.text = _formatDate(picked);
                _calculateNumberOfDays();
              }
            },
            child: Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.calendar, color: backgroundColor, size: 20),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      _startDateController.text.isEmpty
                          ? 'Select start date'
                          : _startDateController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _startDateController.text.isEmpty
                            ? Colors.grey
                            : textColor,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.h),

          // Pickup Days
          _buildSectionTitle('Pickup Days'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _weekDays.map((day) {
              bool isSelected = _selectedDays.contains(day.toLowerCase());
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedDays.remove(day.toLowerCase());
                    } else {
                      _selectedDays.add(day.toLowerCase());
                    }
                    _calculateNumberOfDays();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? backgroundColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? backgroundColor : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    day.substring(0, 3),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : textColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // STEP 5: Review
  Widget _buildStep5Review() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Booking',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            'Please verify all details before confirming',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: textColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 30.h),
          _buildReviewCard(
            title: 'Child',
            value: _selectedChildName ?? 'Not selected',
            icon: Iconsax.user,
          ),
          _buildReviewCard(
            title: 'Driver Type',
            value: _selectedDriverType == 'inhouse'
                ? 'In-House Driver'
                : 'Freelance Driver',
            icon: Iconsax.car,
          ),
          _buildReviewCard(
            title: 'Trip Type',
            value: _selectedTripType == 'return' ? 'Return Trip' : 'One Way',
            icon: Iconsax.repeat,
          ),
          _buildReviewCard(
            title: 'Schedule',
            value: _selectedScheduleType ?? 'Not selected',
            icon: Iconsax.calendar,
          ),
          _buildReviewCard(
            title: 'Start Date',
            value: _startDateController.text.isEmpty
                ? 'Not selected'
                : _startDateController.text,
            icon: Iconsax.calendar_1,
          ),
          _buildReviewCard(
            title: 'Pickup Days',
            value: _selectedDays.isEmpty
                ? 'Not selected'
                : _selectedDays
                    .map((d) => d.substring(0, 3).toUpperCase())
                    .join(', '),
            icon: Iconsax.clock,
          ),
          SizedBox(height: 20.h),
          if (_estimatedPrice != null && _estimatedPrice! > 0)
            _buildPriceCard(),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: backgroundColor, size: 20),
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
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: backgroundColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: isSelected ? backgroundColor.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? backgroundColor : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: backgroundColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? backgroundColor.withOpacity(0.1)
                    : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? backgroundColor : Colors.grey[400],
                size: 20,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? backgroundColor : textColor,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: isSelected
                    ? backgroundColor.withOpacity(0.7)
                    : textColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentStep--),
                  child: Container(
                    height: 56.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Back',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) SizedBox(width: 16.w),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: _handleNext,
                child: Container(
                  height: 56.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        backgroundColor,
                        backgroundColor.withOpacity(0.9)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: backgroundColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    _currentStep == 4 ? 'Confirm Booking' : 'Continue',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext() {
    // Validate each step
    if (_currentStep == 0) {
      if (_selectedChildId == null) {
        Get.snackbar('Required', 'Please select a child',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
    } else if (_currentStep == 1) {
      if (_selectedDriverType == null ||
          _selectedTripType == null ||
          _selectedScheduleType == null) {
        Get.snackbar('Required', 'Please complete all selections',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
    } else if (_currentStep == 2) {
      if (_morningPickupController.text.isEmpty ||
          _morningDropoffController.text.isEmpty ||
          _morningTimeController.text.isEmpty) {
        Get.snackbar('Required', 'Please complete morning trip details',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
      if (_selectedTripType == 'return') {
        if (_afternoonPickupController.text.isEmpty ||
            _afternoonDropoffController.text.isEmpty ||
            _afternoonTimeController.text.isEmpty) {
          Get.snackbar('Required', 'Please complete afternoon trip details',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          return;
        }
      }
    } else if (_currentStep == 3) {
      if (_startDateController.text.isEmpty || _selectedDays.isEmpty) {
        Get.snackbar('Required', 'Please complete schedule details',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
    }

    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      // Final confirmation
      _confirmBooking();
    }
  }

  void _confirmBooking() {
    Get.to(() => ConfirmBooking(
          pickUpLatitude: (_morningPickupLat ?? 0).toString(),
          pickUpLongitude: (_morningPickupLng ?? 0).toString(),
          dropOffLatitude: (_selectedTripType == 'return'
                  ? _afternoonDropoffLat
                  : _morningDropoffLat ?? 0)
              .toString(),
          dropOffLongitude: (_selectedTripType == 'return'
                  ? _afternoonDropoffLng
                  : _morningDropoffLng ?? 0)
              .toString(),
          pickUpLocation: _morningPickupController.text,
          dropOffLocation: _selectedTripType == 'return'
              ? _afternoonDropoffController.text
              : _morningDropoffController.text,
          rideType: _selectedDriverType ?? 'inhouse',
          tripType: _selectedTripType ?? 'one-way',
          schedule: _selectedScheduleType ?? '2 weeks',
          startDate: _startDateController.text,
          pickUpTime: _morningTimeController.text,
          returnTime: _afternoonTimeController.text,
          childName: _selectedChildName ?? '',
          childId: _selectedChildId ?? '',
          // ⭐ ADD THESE NEW PARAMETERS:
          pickupDays: _selectedDays,
          morningFrom: 'home',
          morningTo: 'school',
          morningFromAddress: _morningPickupController.text,
          morningToAddress: _morningDropoffController.text,
          afternoonFrom: 'school',
          afternoonTo: _selectedTripType == 'return' ? 'home' : 'school',
          afternoonFromAddress: _afternoonPickupController.text,
          afternoonToAddress: _afternoonDropoffController.text,
        ));
  }

  String _formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  String _formatTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final DateTime dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat.jm().format(dateTime).toLowerCase();
  }
}
