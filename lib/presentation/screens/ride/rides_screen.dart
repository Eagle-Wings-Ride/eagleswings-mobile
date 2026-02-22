import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/utils/format_date.dart';
import '../../../core/utils/get_status.dart';
import '../../../data/models/book_rides_model.dart';
import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';
import '../ride/book_ride.dart';
import '../ride/single_ride_info_screen.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  final AuthController _authController = Get.find();
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'all';
  String _searchQuery = '';
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _filterOptions = [
    {'value': 'all', 'label': 'All', 'icon': Iconsax.archive},
    {'value': 'booked', 'label': 'Booked', 'icon': Iconsax.calendar},
    {'value': 'paid', 'label': 'Paid', 'icon': Iconsax.wallet},
    {
      'value': 'payment_failed',
      'label': 'Payment Failed',
      'icon': Iconsax.warning_2
    },
    {'value': 'expired', 'label': 'Expired', 'icon': Iconsax.timer_pause},
    {'value': 'assigned', 'label': 'Assigned', 'icon': Iconsax.user},
    {'value': 'ongoing', 'label': 'Ongoing', 'icon': Iconsax.car},
    {'value': 'completed', 'label': 'Completed', 'icon': Iconsax.tick_circle},
    {'value': 'cancelled', 'label': 'Cancelled', 'icon': Iconsax.close_circle},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Booking> get _filteredRides {
    var rides = _authController.recentRides.toList();

    // Filter by status
    if (_selectedFilter != 'all') {
      rides = rides
          .where((ride) =>
              ride.status.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      rides = rides.where((ride) {
        final query = _searchQuery.toLowerCase();
        return ride.child.fullname.toLowerCase().contains(query) ||
            ride.mainPickupAddress.toLowerCase().contains(query) ||
            ride.mainDropoffAddress.toLowerCase().contains(query) ||
            ride.status.toLowerCase().contains(query);
      }).toList();
    }

    // Sort by creation date (newest first)
    rides.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return rides;
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    try {
      // Fetch fresh rides from API using the AuthController
      await _authController.fetchRidesByUser();

      Get.snackbar(
        'Refreshed',
        'Ride list updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh rides: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEFEFF),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: Obx(() {
              if (_authController.recentRides.isEmpty) {
                return _buildEmptyState();
              }

              final filteredRides = _filteredRides;

              if (filteredRides.isEmpty) {
                return _buildNoResultsState();
              }

              return RefreshIndicator(
                onRefresh: _handleRefresh,
                color: backgroundColor,
                child: ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  itemCount: filteredRides.length,
                  itemBuilder: (context, index) {
                    return _buildRideCard(filteredRides[index]);
                  },
                ),
              );
            }),
          ),
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
        'All Rides',
        style: GoogleFonts.poppins(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: _isRefreshing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.refresh, color: Colors.white),
          onPressed: _isRefreshing ? null : _handleRefresh,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      color: backgroundColor,
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by child name or location...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13,
          ),
          prefixIcon: const Icon(Iconsax.search_normal, color: Colors.white),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter['value'];

          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'],
                    size: 16,
                    color: isSelected ? Colors.white : backgroundColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    filter['label'],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : textColor,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.grey[100],
              selectedColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(
                  color: isSelected ? backgroundColor : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter['value'];
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRideCard(Booking ride) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => const SingleRideInfoScreen(),
            arguments: {'rideId': ride.id},
          );
        },
        child: Container(
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - Child and Status
              Row(
                children: [
                  // Child Avatar
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: backgroundColor.withOpacity(0.1),
                      image: ride.child.image != null
                          ? DecorationImage(
                              image: NetworkImage(ride.child.image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: ride.child.image == null
                        ? Center(
                            child: Text(
                              ride.child.fullname.isNotEmpty
                                  ? ride.child.fullname[0].toUpperCase()
                                  : 'C',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: backgroundColor,
                              ),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  // Child Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ride.child.fullname,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        Text(
                          '${ride.child.age} years • Grade ${ride.child.grade}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(ride.status.toLowerCase())
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      ride.status.capitalizeFirst!,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: getStatusColor(ride.status.toLowerCase()),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              // Trip Route
              Row(
                children: [
                  // Route Icons
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.radio_button_checked,
                          color: Colors.green,
                          size: 12,
                        ),
                      ),
                      ...List.generate(
                        3,
                        (index) => Container(
                          width: 2,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  // Addresses
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ride.mainPickupAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          ride.mainDropoffAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              // Footer - Trip Type, Schedule, Date
              Row(
                children: [
                  _buildInfoChip(
                    icon: Iconsax.repeat,
                    label: ride.isReturnTrip ? 'Return' : 'One Way',
                    color: const Color(0xff133BB7),
                  ),
                  SizedBox(width: 8.w),
                  _buildInfoChip(
                    icon: Iconsax.calendar,
                    label: ride.scheduleType,
                    color: backgroundColor,
                  ),
                  const Spacer(),
                  Icon(
                    Iconsax.clock,
                    size: 14,
                    color: textColor.withOpacity(0.5),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    formatDate(ride.createdAt.toString()),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),

              // Driver Info (if assigned)
              if (ride.hasDrivers) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.driver,
                        size: 14,
                        color: backgroundColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Driver: ${ride.primaryDriver!.fullname}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: ride.primaryDriver!.isAvailable
                              ? Colors.green.withOpacity(0.15)
                              : Colors.grey.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          ride.primaryDriver!.status.capitalizeFirst!,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: ride.primaryDriver!.isAvailable
                                ? Colors.green
                                : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.car,
                size: 80,
                color: backgroundColor,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'No Rides Yet',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start by booking your first ride for your child',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.to(() => const BookRide()),
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                'Book a Ride',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.search_normal,
              size: 80,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            Text(
              'No Rides Found',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No rides match your search "$_searchQuery"'
                  : 'No ${_selectedFilter != 'all' ? _selectedFilter : ''} rides found',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'all';
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              child: Text(
                'Clear Filters',
                style: GoogleFonts.poppins(
                  color: backgroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
