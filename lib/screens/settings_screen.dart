import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/theme_provider.dart';
import '../utils/responsive_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? WhatsAppColors.darkBackground
          : WhatsAppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: isDark
            ? WhatsAppColors.darkAppBarBackground
            : WhatsAppColors.lightAppBarBackground,
        elevation: 1,
      ),
      body: ResponsiveBuilder(
        builder: (context, info) {
          return ListView(
            padding: info.screenPadding,
            children: [
              // Profile section
              _buildProfileSection(context),
              const SizedBox(height: 24),

              // Account settings
              _buildSectionTitle(context, 'Account'),
              _buildSettingsTile(
                context: context,
                icon: Icons.key,
                title: 'Account',
                subtitle: 'Security notifications, change number',
                onTap: () {},
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.lock,
                title: 'Privacy',
                subtitle: 'Block contacts, disappearing messages',
                onTap: () {},
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.favorite,
                title: 'Avatar',
                subtitle: 'Create, edit, profile photo',
                onTap: () {},
              ),

              const SizedBox(height: 24),

              // App settings
              _buildSectionTitle(context, 'App Settings'),
              _buildSettingsTile(
                context: context,
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Message, group & call tones',
                onTap: () {},
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.folder,
                title: 'Storage and data',
                subtitle: 'Network usage, auto-download',
                onTap: () {},
              ),
              _buildThemeSettingsTile(context),
              _buildSettingsTile(
                context: context,
                icon: Icons.language,
                title: 'App language',
                subtitle: 'English (phone\'s language)',
                onTap: () {},
              ),

              const SizedBox(height: 24),

              // Help section
              _buildSectionTitle(context, 'Support'),
              _buildSettingsTile(
                context: context,
                icon: Icons.help_outline,
                title: 'Help',
                subtitle: 'Help center, contact us, privacy policy',
                onTap: () {},
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.group_add,
                title: 'Invite a friend',
                subtitle: 'Share WhatsApp with friends',
                onTap: () {},
              ),

              const SizedBox(height: 48),

              // App info
              _buildAppInfo(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? WhatsAppColors.darkSurface : Colors.white,
        borderRadius: ResponsiveHelper.getResponsiveBorderRadius(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            offset: const Offset(0, 2),
            blurRadius: ResponsiveHelper.getElevation(context, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: ResponsiveHelper.getIconSize(context, 30),
            backgroundColor: WhatsAppColors.primaryGreen,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: ResponsiveHelper.getIconSize(context, 30),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Name',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: ResponsiveHelper.getFontSize(context, 18),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Available',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: ResponsiveHelper.getFontSize(context, 14),
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.qr_code,
            color: WhatsAppColors.primaryGreen,
            size: ResponsiveHelper.getIconSize(context, 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: ResponsiveHelper.getFontSize(context, 14),
          fontWeight: FontWeight.w500,
          color: WhatsAppColors.primaryGreen,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? WhatsAppColors.darkSurface : Colors.white,
        borderRadius: ResponsiveHelper.getResponsiveBorderRadius(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.1 : 0.03),
            offset: const Offset(0, 1),
            blurRadius: ResponsiveHelper.getElevation(context, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: ResponsiveHelper.getHorizontalPadding(context),
        leading: Icon(
          icon,
          color: isDark ? WhatsAppColors.iconDark : WhatsAppColors.iconLight,
          size: ResponsiveHelper.getIconSize(context, 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 16),
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 13),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios,
              size: ResponsiveHelper.getIconSize(context, 16),
              color: Theme.of(context).colorScheme.secondary,
            ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildThemeSettingsTile(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return _buildSettingsTile(
          context: context,
          icon: Icons.palette,
          title: 'Theme',
          subtitle: 'Light, dark, or system default',
          onTap: () => _showThemeDialog(context, themeProvider),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                themeProvider.themeDisplayName,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, 13),
                  color: WhatsAppColors.primaryGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: ResponsiveHelper.getIconSize(context, 16),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              themeProvider,
              ThemeMode.light,
              'Light',
              Icons.light_mode,
            ),
            _buildThemeOption(
              context,
              themeProvider,
              ThemeMode.dark,
              'Dark',
              Icons.dark_mode,
            ),
            _buildThemeOption(
              context,
              themeProvider,
              ThemeMode.system,
              'System default',
              Icons.settings_system_daydream,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider themeProvider,
    ThemeMode mode,
    String title,
    IconData icon,
  ) {
    final isSelected = themeProvider.themeMode == mode;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? WhatsAppColors.primaryGreen : null,
      ),
      title: Text(title),
      trailing: isSelected
          ? const Icon(Icons.check, color: WhatsAppColors.primaryGreen)
          : null,
      onTap: () {
        themeProvider.setThemeMode(mode);
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'WhatsApp Clone',
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 16),
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 12),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Made with ❤️ in Flutter',
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 12),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
