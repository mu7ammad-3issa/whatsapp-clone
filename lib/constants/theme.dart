import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

class WhatsAppTheme {
  // Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // Responsive padding and margins
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= tabletBreakpoint) {
      return const EdgeInsets.all(24);
    } else if (screenWidth >= mobileBreakpoint) {
      return const EdgeInsets.all(20);
    } else {
      return const EdgeInsets.all(16);
    }
  }
  
  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= tabletBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 32);
    } else if (screenWidth >= mobileBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 24);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16);
    }
  }
  
  // Responsive text scaling
  static double getResponsiveTextScale(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= tabletBreakpoint) {
      return 1.1;
    } else if (screenWidth >= mobileBreakpoint) {
      return 1.05;
    } else {
      return 1.0;
    }
  }
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false, // WhatsApp uses Material 2 design
    brightness: Brightness.light,
    primaryColor: WhatsAppColors.primaryGreen,
    primarySwatch: _createMaterialColor(WhatsAppColors.primaryGreen),
    colorScheme: const ColorScheme.light(
      primary: WhatsAppColors.primaryGreen,
      surface: WhatsAppColors.lightBackground,
      onSurface: WhatsAppColors.lightPrimary,
      secondary: WhatsAppColors.lightSecondary,
      outline: WhatsAppColors.lightDivider,
    ),
    scaffoldBackgroundColor: WhatsAppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: WhatsAppColors.lightAppBarBackground,
      foregroundColor: Colors.white,
      elevation: 4,
      shadowColor: Colors.black26,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 19,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI', // WhatsApp font
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.white,
        size: 24,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: WhatsAppColors.lightBackground,
      selectedItemColor: WhatsAppColors.primaryGreen,
      unselectedItemColor: WhatsAppColors.lightSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: WhatsAppColors.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 6,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: WhatsAppColors.lightPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI',
      ),
      headlineMedium: TextStyle(
        color: WhatsAppColors.lightPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI',
      ),
      bodyLarge: TextStyle(
        color: WhatsAppColors.lightPrimary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: 'Segoe UI',
      ),
      bodyMedium: TextStyle(
        color: WhatsAppColors.lightSecondary,
        fontSize: 13,
        fontWeight: FontWeight.normal,
        fontFamily: 'Segoe UI',
      ),
      bodySmall: TextStyle(
        color: WhatsAppColors.lightTertiary,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: 'Segoe UI',
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: WhatsAppColors.lightDivider,
      thickness: 0.5,
    ),
    cardTheme: const CardTheme(
      color: WhatsAppColors.lightBackground,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    primaryColor: WhatsAppColors.primaryGreen,
    primarySwatch: _createMaterialColor(WhatsAppColors.primaryGreen),
    colorScheme: const ColorScheme.dark(
      primary: WhatsAppColors.primaryGreen,
      surface: WhatsAppColors.darkBackground,
      onSurface: WhatsAppColors.darkPrimary,
      secondary: WhatsAppColors.darkSecondary,
      outline: WhatsAppColors.darkDivider,
    ),
    scaffoldBackgroundColor: WhatsAppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: WhatsAppColors.darkAppBarBackground,
      foregroundColor: WhatsAppColors.darkPrimary,
      elevation: 4,
      shadowColor: Colors.black54,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        color: WhatsAppColors.darkPrimary,
        fontSize: 19,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI',
      ),
      iconTheme: IconThemeData(
        color: WhatsAppColors.iconDark,
        size: 24,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: WhatsAppColors.darkSurface,
      selectedItemColor: WhatsAppColors.primaryGreen,
      unselectedItemColor: WhatsAppColors.darkSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: WhatsAppColors.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 6,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: WhatsAppColors.darkPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI',
      ),
      headlineMedium: TextStyle(
        color: WhatsAppColors.darkPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI',
      ),
      bodyLarge: TextStyle(
        color: WhatsAppColors.darkPrimary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: 'Segoe UI',
      ),
      bodyMedium: TextStyle(
        color: WhatsAppColors.darkSecondary,
        fontSize: 13,
        fontWeight: FontWeight.normal,
        fontFamily: 'Segoe UI',
      ),
      bodySmall: TextStyle(
        color: WhatsAppColors.darkTertiary,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: 'Segoe UI',
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: WhatsAppColors.darkDivider,
      thickness: 0.5,
    ),
    cardTheme: const CardTheme(
      color: WhatsAppColors.darkSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: WhatsAppColors.primaryGreen,
      unselectedLabelColor: WhatsAppColors.darkSecondary,
      indicatorColor: WhatsAppColors.primaryGreen,
      indicatorSize: TabBarIndicatorSize.tab,
    ),
  );

  // Helper method to create MaterialColor
  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}
