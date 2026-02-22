import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../../injection_container.dart' as di;
import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';

class RatingScreen extends StatefulWidget {
  final String bookingId;
  final Map<String, dynamic> driverInfo;

  const RatingScreen({
    super.key,
    required this.bookingId,
    required this.driverInfo,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final AuthController _authController = Get.find();
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final List<String> _selectedTags = [];
  bool _isSubmitting = false;

  final List<String> _positiveTags = [
    'Friendly',
    'On Time',
    'Clean Car',
    'Safe Driving',
    'Professional',
    'Great Communication',
  ];

  final List<String> _negativeTags = [
    'Late',
    'Rude',
    'Unsafe Driving',
    'Dirty Car',
    'Wrong Route',
    'Poor Communication',
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Rate Your Ride',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            _buildDriverInfo(),
            SizedBox(height: 30.h),
            _buildRatingStars(),
            SizedBox(height: 30.h),
            if (_rating > 0) ...[
              _buildTags(),
              SizedBox(height: 25.h),
              _buildReviewInput(),
              SizedBox(height: 30.h),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _rating > 0 ? _buildSubmitButton() : null,
    );
  }

  Widget _buildDriverInfo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor.withOpacity(0.2),
            image: widget.driverInfo['profile_photo'] != null
                ? DecorationImage(
                    image: NetworkImage(widget.driverInfo['profile_photo']),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: widget.driverInfo['profile_photo'] == null
              ? Center(
                  child: Text(
                    widget.driverInfo['name']?.substring(0, 1).toUpperCase() ??
                        'D',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: backgroundColor,
                    ),
                  ),
                )
              : null,
        ),
        SizedBox(height: 15.h),
        Text(
          widget.driverInfo['name'] ?? 'Driver',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.driverInfo['car_model'] != null)
          Text(
            '${widget.driverInfo['car_model']} • ${widget.driverInfo['car_plate'] ?? ''}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }

  Widget _buildRatingStars() {
    return Column(
      children: [
        Text(
          _rating == 0
              ? 'How was your ride?'
              : _rating <= 2
                  ? 'What went wrong?'
                  : _rating == 3
                      ? 'It was okay'
                      : _rating == 4
                          ? 'Great ride!'
                          : 'Excellent!',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => setState(() => _rating = index + 1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  size: 50,
                  color: index < _rating ? Colors.amber : Colors.grey[400],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTags() {
    final tags = _rating >= 4 ? _positiveTags : _negativeTags;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _rating >= 4 ? 'What did you like?' : 'What can be improved?',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: tags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedTags.remove(tag);
                  } else {
                    _selectedTags.add(tag);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? backgroundColor : Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? backgroundColor : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: isSelected ? Colors.white : textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReviewInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add a written review (optional)',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15.h),
        TextField(
          controller: _reviewController,
          maxLines: 5,
          maxLength: 500,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Share more about your experience...',
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: backgroundColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
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
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitRating,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Submit Rating',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _submitRating() async {
    if (_rating == 0) {
      Get.snackbar(
        'Error',
        'Please select a rating',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // TODO: Call API to submit rating
      // Example:
      // await _authController.submitRating(
      //   bookingId: widget.bookingId,
      //   rating: _rating,
      //   tags: _selectedTags,
      //   review: _reviewController.text,
      // );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      setState(() => _isSubmitting = false);

      Get.back();
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Thank You!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your feedback helps us improve',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: textColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      setState(() => _isSubmitting = false);
      Get.snackbar(
        'Error',
        'Failed to submit rating: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
