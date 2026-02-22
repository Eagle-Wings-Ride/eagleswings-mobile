import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../injection_container.dart' as di;
import '../../../navigation_page.dart';
import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String bookingId;
  final Map<String, dynamic>? bookingDetails;
  final bool isRenewal;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.bookingId,
    this.bookingDetails,
    this.isRenewal = false,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final AuthController _authController = Get.find();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Payment',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountCard(),
            SizedBox(height: 30.h),
            _buildBookingDetails(),
            SizedBox(height: 30.h),
            _buildPaymentInfo(),
          ],
        ),
      ),
      bottomNavigationBar: _buildPayButton(),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Amount',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            '\$${widget.amount.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Booking ID: ${widget.bookingId.substring(0, 10)}...',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    if (widget.bookingDetails == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Details',
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
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                  'Child', widget.bookingDetails!['childName'] ?? 'N/A'),
              _buildDetailRow(
                  'Trip Type', widget.bookingDetails!['tripType'] ?? 'N/A'),
              _buildDetailRow(
                  'Schedule', widget.bookingDetails!['schedule'] ?? 'N/A'),
              _buildDetailRow(
                  'Start Date', widget.bookingDetails!['startDate'] ?? 'N/A'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    final displayValue = value?.toString().trim().isNotEmpty == true
        ? value.toString()
        : 'N/A';

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: textColor.withOpacity(0.6),
            ),
          ),
          Text(
            displayValue,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700]),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'You will be redirected to our secure payment gateway powered by Stripe',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.blue[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
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
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.isRenewal
                        ? 'Renew Payment'
                        : 'Proceed to Payment',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ],
              ),
      ),
    );
  }

  Future<void> _processPayment() async {
    await _startPaymentFlow(renew: widget.isRenewal);
  }

  Future<void> _startPaymentFlow({required bool renew}) async {
    setState(() => _isProcessing = true);

    try {
      final response = renew
          ? await _authController.renewPayment(
              bookingId: widget.bookingId,
              currency: 'cad',
            )
          : await _authController.makePayment(
              bookingId: widget.bookingId,
              currency: 'cad',
            );

      setState(() => _isProcessing = false);

      if (response.hasCheckoutUrl) {
        final checkoutUrl = response.checkoutUrl!;
        final uri = Uri.tryParse(checkoutUrl);
        if (uri == null) {
          throw Exception('Invalid checkout URL returned by server');
        }

        if (!await canLaunchUrl(uri)) {
          throw Exception('Could not open payment URL');
        }

        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        _showPostCheckoutDialog(
          renew: renew,
          message: response.message,
        );
        return;
      }

      if ((response.message ?? '').isNotEmpty) {
        _showStatusDialog(response.message!);
        return;
      }

      throw Exception('Payment response did not include a checkout URL');
    } catch (e) {
      setState(() => _isProcessing = false);
      Get.snackbar(
        'Payment Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: backgroundColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  void _showStatusDialog(String message) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: backgroundColor),
            SizedBox(width: 10.w),
            Text(
              'Payment Status',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: textColor.withOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _reconcilePaymentStatus();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Check Status',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showPostCheckoutDialog({
    required bool renew,
    String? message,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: backgroundColor),
            SizedBox(width: 10.w),
            Text(
              renew ? 'Renewal Started' : 'Payment Started',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          message ??
              'Complete your payment in the browser, then confirm below so we can refresh your ride status.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: textColor.withOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _reconcilePaymentStatus();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'I Completed Payment',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _reconcilePaymentStatus() async {
    setState(() => _isProcessing = true);
    try {
      final statusResult =
          await _authController.refreshPaymentStatus(widget.bookingId);

      if (statusResult.isPaidOrActive) {
        Get.snackbar(
          'Success',
          'Payment confirmed. Your ride is now ${statusResult.status ?? 'active'}.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: backgroundColor,
          colorText: Colors.white,
        );

        Get.offAll(() => const NavigationPage(initialTab: 1));
        return;
      }

      final normalizedStatus = statusResult.status ?? 'unknown';
      if (statusResult.needsRenewal) {
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Payment Not Completed',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Current status is "$normalizedStatus". You can retry with Renew Payment.',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Later',
                  style: GoogleFonts.poppins(
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Get.back();
                  await _startPaymentFlow(renew: true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Renew Payment',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar(
          'Payment Pending',
          'Current ride status: $normalizedStatus. Please try checking again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: backgroundColor,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Status Check Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: backgroundColor,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }
}
