import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/string_extensions.dart';
import '../../../data/models/book_rides_model.dart';
import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';
import 'single_ride_info_screen.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  final AuthController _authController = Get.find();

  String _selectedFilter = 'all';
  String _selectedTimeRange = 'all_time';

  final List<String> _filterOptions = [
    'all',
    'completed',
    'cancelled',
  ];

  final List<Map<String, String>> _timeRangeOptions = [
    {'value': 'all_time', 'label': 'All Time'},
    {'value': 'this_week', 'label': 'This Week'},
    {'value': 'this_month', 'label': 'This Month'},
    {'value': 'last_month', 'label': 'Last Month'},
    {'value': 'custom', 'label': 'Custom Range'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: page,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildTripsList()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Trip History',
        style: GoogleFonts.poppins(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.export, color: Colors.white),
          onPressed: _exportHistory,
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(20.w),
      color: Colors.white,
      child: Column(
        children: [
          // Status Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterOptions.map((filter) {
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? backgroundColor
                          : backgroundColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      filter.capitalizeFirstInfo,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: isSelected ? Colors.white : textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 15.h),
          // Time Range Filter
          GestureDetector(
            onTap: _showTimeRangePicker,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.calendar, color: backgroundColor, size: 20),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      _getTimeRangeLabel(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: textColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripsList() {
    return Obx(() {
      final trips = _getFilteredTrips();

      if (trips.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: _refreshTrips,
        color: backgroundColor,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          itemCount: trips.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            return _buildTripCard(trips[index]);
          },
        ),
      );
    });
  }

  Widget _buildTripCard(Booking trip) {
    final statusColor = _getStatusColor(trip.status);

    return GestureDetector(
      onTap: () => Get.to(
        () => const SingleRideInfoScreen(),
        arguments: {'rideId': trip.id},
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      trip.status == 'completed'
                          ? Iconsax.tick_circle
                          : Iconsax.close_circle,
                      color: statusColor,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              trip.child.fullname.capitalizeFirst ?? 'Ride',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                trip.status.capitalizeFirst!,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          DateFormat('MMM dd, yyyy • hh:mm a')
                              .format(trip.createdAt),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTripDetail(
                      Iconsax.routing, 'One Way', trip.tripType == 'one_way'),
                  _buildTripDetail(Iconsax.calendar_tick, 'Scheduled',
                      trip.scheduleType == 'scheduled'),
                  Text(
                    'View Details',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: backgroundColor,
                      fontWeight: FontWeight.w600,
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

  Widget _buildTripDetail(IconData icon, String label, bool isActive) {
    if (!isActive) return const SizedBox();
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xff39BF4E);
      case 'cancelled':
        return const Color(0xffE70000);
      case 'pending':
        return const Color(0xffFFB800);
      default:
        return Colors.grey;
    }
  }

  // REMOVED UNUSED METHODS

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.car,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20.h),
          Text(
            'No trips found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Your completed trips will appear here',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: textColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  List<Booking> _getFilteredTrips() {
    var trips = _authController.recentRides.toList();

    // Filter by status
    if (_selectedFilter != 'all') {
      trips = trips
          .where((trip) => trip.status.toLowerCase() == _selectedFilter)
          .toList();
    } else {
      // For history, show only completed and cancelled
      trips = trips
          .where((trip) =>
              trip.status.toLowerCase() == 'completed' ||
              trip.status.toLowerCase() == 'cancelled')
          .toList();
    }

    // Filter by time range
    if (_selectedTimeRange != 'all_time') {
      final now = DateTime.now();
      DateTime startDate;

      switch (_selectedTimeRange) {
        case 'this_week':
          startDate = now.subtract(Duration(days: now.weekday - 1));
          break;
        case 'this_month':
          startDate = DateTime(now.year, now.month, 1);
          break;
        case 'last_month':
          startDate = DateTime(now.year, now.month - 1, 1);
          final endDate = DateTime(now.year, now.month, 0);
          trips = trips
              .where((trip) =>
                  trip.createdAt.isAfter(startDate) &&
                  trip.createdAt.isBefore(endDate))
              .toList();
          return trips;
        default:
          startDate = now;
      }

      trips = trips.where((trip) => trip.createdAt.isAfter(startDate)).toList();
    }

    return trips;
  }

  String _getTimeRangeLabel() {
    final option = _timeRangeOptions.firstWhere(
      (opt) => opt['value'] == _selectedTimeRange,
      orElse: () => _timeRangeOptions[0],
    );
    return option['label']!;
  }

  void _showTimeRangePicker() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.sp),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Select Time Range',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),
            ..._timeRangeOptions.map((option) {
              return RadioListTile<String>(
                title: Text(
                  option['label']!,
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                value: option['value']!,
                groupValue: _selectedTimeRange,
                activeColor: backgroundColor,
                onChanged: (value) {
                  setState(() => _selectedTimeRange = value!);
                  Get.back();
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // ⭐ UPDATED - Works with your current setup, no fetchRidesByUser needed
  Future<void> _refreshTrips() async {
    // Refresh rides from API
    await _authController.fetchRidesByUser();

    // Small delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _exportHistory() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.sp),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Trip History',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text('Export as PDF', style: GoogleFonts.poppins()),
              onTap: () {
                Get.back();
                Get.snackbar(
                    'Coming Soon', 'PDF export will be available soon');
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: Text('Export as Excel', style: GoogleFonts.poppins()),
              onTap: () {
                Get.back();
                Get.snackbar(
                    'Coming Soon', 'Excel export will be available soon');
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: Text('Email Report', style: GoogleFonts.poppins()),
              onTap: () {
                Get.back();
                Get.snackbar(
                    'Coming Soon', 'Email feature will be available soon');
              },
            ),
          ],
        ),
      ),
    );
  }

  // REMOVED UNUSED _formatDate
}
