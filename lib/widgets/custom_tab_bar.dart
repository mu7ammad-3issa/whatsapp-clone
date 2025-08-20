import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<Widget> tabs;

  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TabBar(
      controller: controller,
      tabs: tabs,
      indicatorColor: WhatsAppColors.primaryGreen,
      indicatorWeight: 2.5,
      labelColor: WhatsAppColors.primaryGreen,
      unselectedLabelColor: isDark 
          ? WhatsAppColors.darkSecondary 
          : WhatsAppColors.lightSecondary,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}
