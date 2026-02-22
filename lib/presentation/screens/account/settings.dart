import 'package:eaglerides/presentation/screens/account/edit_profile.dart';
import 'package:eaglerides/presentation/screens/account/faq.dart';
import 'package:eaglerides/presentation/screens/account/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../styles/styles.dart';
import '../../controller/auth/auth_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthController _authController = Get.find();

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
          'Settings',
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
            SizedBox(height: 20.h),
            _buildSection(
              'Account',
              [
                _buildSettingsTile(
                  icon: Iconsax.user,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () => Get.to(() => const EditProfileScreen()),
                ),
                _buildSettingsTile(
                  icon: Iconsax.profile_2user,
                  title: 'Manage Children',
                  subtitle: 'View and edit child profiles',
                  onTap: () => _showChildrenList(),
                ),
              ],
            ),
            _buildSection(
              'Support',
              [
                _buildSettingsTile(
                  icon: Iconsax.message_question,
                  title: 'Help & Support',
                  subtitle: 'Get help or contact us',
                  onTap: () => _showHelpDialog(),
                ),
                _buildSettingsTile(
                  icon: Iconsax.document,
                  title: 'FAQ',
                  subtitle: 'Frequently asked questions',
                  onTap: () => Get.to(() => const FAQ()),
                ),
                _buildSettingsTile(
                  icon: Iconsax.shield_tick,
                  title: 'Terms & Conditions',
                  subtitle: 'Read our terms',
                  onTap: () => Get.to(() => const TermsAndConditionsView()),
                ),
              ],
            ),
            _buildSection(
              'About',
              [
                _buildSettingsTile(
                  icon: Iconsax.info_circle,
                  title: 'App Version',
                  subtitle: 'Version 1.0.0',
                  onTap: null,
                ),
              ],
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor.withOpacity(0.6),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (textColor ?? backgroundColor).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: textColor ?? backgroundColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: onTap != null
          ? const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          : null,
      onTap: onTap,
    );
  }

  // ==================== DIALOGS & ACTIONS ====================

  void _showChildrenList() {
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
              'Your Children',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),
            Obx(() {
              final children = _authController.children;
              if (children.isEmpty) {
                return const Text('No children added yet');
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: children.length,
                itemBuilder: (context, index) {
                  final child = children[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: child.image != null
                          ? NetworkImage(child.image!)
                          : null,
                      child:
                          child.image == null ? Text(child.fullname[0]) : null,
                    ),
                    title: Text(child.fullname),
                    subtitle: Text('Age: ${child.age} | Grade: ${child.grade}'),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Help & Support',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need help? Contact us:',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 15),
            _buildContactOption(Icons.email, 'support@eaglerides.com'),
            _buildContactOption(Icons.phone, '+1 (555) 123-4567'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(color: backgroundColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: backgroundColor, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
