import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../styles/styles.dart';

class DriverProfileScreen extends StatefulWidget {
  final Map<String, dynamic> driverData;

  const DriverProfileScreen({
    super.key,
    required this.driverData,
  });

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: page,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Driver Profile',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 20.h),
            _buildStatsCards(),
            SizedBox(height: 25.h),
            _buildAboutSection(),
            SizedBox(height: 25.h),
            _buildVehicleInfo(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: EdgeInsets.only(bottom: 40.h),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 4),
              image: widget.driverData['profile_photo'] != null
                  ? DecorationImage(
                      image: NetworkImage(widget.driverData['profile_photo']),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: widget.driverData['profile_photo'] == null
                ? Center(
                    child: Text(
                      widget.driverData['name']
                              ?.substring(0, 1)
                              .toUpperCase() ??
                          'D',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: backgroundColor,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(height: 15.h),
          Text(
            widget.driverData['name'] ?? 'Driver',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 18),
              SizedBox(width: 5.w),
              Text(
                '${widget.driverData['rating'] ?? 0.0}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                ' • ${widget.driverData['total_rides'] ?? 0} trips',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Available',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Iconsax.driving,
              label: 'Total Trips',
              value: '${widget.driverData['total_rides'] ?? 0}',
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              icon: Iconsax.clock,
              label: 'Experience',
              value: '${widget.driverData['years_experience'] ?? 0}+ yrs',
              color: Colors.purple,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              icon: Iconsax.star,
              label: 'Rating',
              value: '${widget.driverData['rating'] ?? 0.0}',
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: textColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Iconsax.call,
                  label: 'Phone',
                  value: widget.driverData['phone_number'] ?? 'N/A',
                ),
                if (widget.driverData['email'] != null) ...[
                  Divider(height: 24.h),
                  _buildInfoRow(
                    icon: Iconsax.sms,
                    label: 'Email',
                    value: widget.driverData['email'] ?? 'N/A',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Information',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Iconsax.car,
                  label: 'Vehicle',
                  value: widget.driverData['car_model'] ?? 'N/A',
                ),
                Divider(height: 24.h),
                _buildInfoRow(
                  icon: Iconsax.card,
                  label: 'License Plate',
                  value: widget.driverData['car_plate'] ?? 'N/A',
                ),
                if (widget.driverData['car_color'] != null) ...[
                  Divider(height: 24.h),
                  _buildInfoRow(
                    icon: Iconsax.color_swatch,
                    label: 'Color',
                    value: widget.driverData['car_color'] ?? 'N/A',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: backgroundColor, size: 18),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
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
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _callDriver(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                side: BorderSide(color: backgroundColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: Icon(Iconsax.call, color: backgroundColor, size: 20),
              label: Text(
                'Call',
                style: GoogleFonts.poppins(
                  color: backgroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _messageDriver(),
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Iconsax.message, color: Colors.white, size: 20),
              label: Text(
                'Message',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callDriver() async {
    final phone = widget.driverData['phone_number'];
    if (phone == null || phone.isEmpty) {
      Get.snackbar(
        'Error',
        'Phone number not available',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final Uri phoneUri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch phone app',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _messageDriver() async {
    final phone = widget.driverData['phone_number'];
    if (phone == null || phone.isEmpty) {
      Get.snackbar(
        'Error',
        'Phone number not available',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final Uri smsUri = Uri.parse('sms:$phone');
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch messaging app',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
