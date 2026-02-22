import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../styles/styles.dart';

class SupportHelpScreen extends StatefulWidget {
  const SupportHelpScreen({super.key});

  @override
  State<SupportHelpScreen> createState() => _SupportHelpScreenState();
}

class _SupportHelpScreenState extends State<SupportHelpScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedCategory = 'general';

  final List<Map<String, dynamic>> _categories = [
    {'value': 'general', 'label': 'General Inquiry', 'icon': Iconsax.message_question},
    {'value': 'booking', 'label': 'Booking Issue', 'icon': Iconsax.calendar},
    {'value': 'payment', 'label': 'Payment Problem', 'icon': Iconsax.wallet},
    {'value': 'driver', 'label': 'Driver Complaint', 'icon': Iconsax.user},
    {'value': 'technical', 'label': 'Technical Issue', 'icon': Iconsax.setting_2},
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

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
          'Help & Support',
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
            _buildQuickActions(),
            SizedBox(height: 20.h),
            _buildContactForm(),
            SizedBox(height: 20.h),
            _buildFAQSection(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Iconsax.call,
                  label: 'Call Us',
                  color: Colors.green,
                  onTap: () {
                    // TODO: Open dialer
                    Get.snackbar('Calling', 'Opening dialer...');
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildActionCard(
                  icon: Iconsax.sms,
                  label: 'Email',
                  color: Colors.blue,
                  onTap: () {
                    // TODO: Open email
                    Get.snackbar('Email', 'Opening email app...');
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Iconsax.message,
                  label: 'Live Chat',
                  color: Colors.purple,
                  onTap: () {
                    // TODO: Open chat
                    Get.snackbar('Chat', 'Starting live chat...');
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildActionCard(
                  icon: Iconsax.message_question,
                  label: 'FAQ',
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to FAQ
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8.h),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submit a Ticket',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Category',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category['value'];
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = category['value']),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? backgroundColor
                        : backgroundColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        category['icon'],
                        size: 16,
                        color: isSelected ? Colors.white : textColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        category['label'],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isSelected ? Colors.white : textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20.h),
          Text(
            'Subject',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: _subjectController,
            style: GoogleFonts.poppins(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Brief description of your issue',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(16.sp),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Message',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: _messageController,
            maxLines: 5,
            style: GoogleFonts.poppins(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Describe your issue in detail...',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(16.sp),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Submit Ticket',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'question': 'How do I book a ride?',
        'answer': 'Tap on "Book Ride" button on home screen, select your child, configure trip details, and confirm booking.',
      },
      {
        'question': 'How can I cancel a booking?',
        'answer': 'Go to your ride details and tap "Cancel Ride". Note that cancellation policies apply.',
      },
      {
        'question': 'What payment methods are accepted?',
        'answer': 'We accept credit/debit cards, PayPal, Apple Pay, and Google Pay.',
      },
      {
        'question': 'How do I track my child\'s ride?',
        'answer': 'For ongoing rides, tap "Track Live" to see real-time location and ETA.',
      },
      {
        'question': 'How can I rate my driver?',
        'answer': 'After ride completion, you\'ll be prompted to rate and review the driver.',
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Frequently Asked Questions',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full FAQ
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
                    color: backgroundColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          ...faqs.map((faq) => _buildFAQItem(
                question: faq['question']!,
                answer: faq['answer']!,
              )),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        question,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Text(
            answer,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: textColor.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  void _submitTicket() {
    if (_subjectController.text.isEmpty || _messageController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // TODO: Implement API call to submit ticket
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
              'Ticket Submitted!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We\'ll get back to you within 24 hours',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
                _subjectController.clear();
                _messageController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Done',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}