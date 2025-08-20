import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < desktopBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
    }
  }

  static EdgeInsets getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 32);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16);
    }
  }

  static double getTextScaleFactor(BuildContext context) {
    if (isDesktop(context)) {
      return 1.1;
    } else if (isTablet(context)) {
      return 1.05;
    } else {
      return 1.0;
    }
  }

  static double getFontSize(BuildContext context, double baseSize) {
    return baseSize * getTextScaleFactor(context);
  }

  static double getIconSize(BuildContext context, double baseSize) {
    if (isDesktop(context)) {
      return baseSize * 1.2;
    } else if (isTablet(context)) {
      return baseSize * 1.1;
    } else {
      return baseSize;
    }
  }

  static double getListTileHeight(BuildContext context) {
    if (isDesktop(context)) {
      return 80.0;
    } else if (isTablet(context)) {
      return 75.0;
    } else {
      return 72.0;
    }
  }

  static double getAppBarHeight(BuildContext context) {
    if (isDesktop(context)) {
      return 60.0;
    } else if (isTablet(context)) {
      return 58.0;
    } else {
      return 56.0;
    }
  }

  static double getMaxChatWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (isDesktop(context)) {
      return screenWidth * 0.65; // 65% on desktop
    } else if (isTablet(context)) {
      return screenWidth * 0.75; // 75% on tablet
    } else {
      return screenWidth * 0.85; // 85% on mobile
    }
  }

  static int getChatGridColumns(BuildContext context) {
    if (isDesktop(context)) {
      return 3;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 1;
    }
  }

  static double getBottomSheetMaxHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.9;
  }

  static BorderRadius getResponsiveBorderRadius(BuildContext context) {
    if (isDesktop(context)) {
      return BorderRadius.circular(16);
    } else if (isTablet(context)) {
      return BorderRadius.circular(14);
    } else {
      return BorderRadius.circular(12);
    }
  }

  static double getElevation(BuildContext context, double baseElevation) {
    if (isDesktop(context)) {
      return baseElevation * 1.5;
    } else if (isTablet(context)) {
      return baseElevation * 1.2;
    } else {
      return baseElevation;
    }
  }

  static Duration getAnimationDuration(BuildContext context) {
    if (isDesktop(context)) {
      return const Duration(milliseconds: 350);
    } else if (isTablet(context)) {
      return const Duration(milliseconds: 300);
    } else {
      return const Duration(milliseconds: 250);
    }
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveInfo info) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final info = ResponsiveInfo(context);
    return builder(context, info);
  }
}

class ResponsiveInfo {
  final BuildContext context;
  final double width;
  final double height;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  ResponsiveInfo(this.context)
      : width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height,
        isMobile = ResponsiveHelper.isMobile(context),
        isTablet = ResponsiveHelper.isTablet(context),
        isDesktop = ResponsiveHelper.isDesktop(context);

  EdgeInsets get screenPadding => ResponsiveHelper.getScreenPadding(context);
  EdgeInsets get horizontalPadding =>
      ResponsiveHelper.getHorizontalPadding(context);
  double get textScaleFactor => ResponsiveHelper.getTextScaleFactor(context);
  BorderRadius get borderRadius =>
      ResponsiveHelper.getResponsiveBorderRadius(context);
  Duration get animationDuration =>
      ResponsiveHelper.getAnimationDuration(context);

  double fontSize(double baseSize) =>
      ResponsiveHelper.getFontSize(context, baseSize);
  double iconSize(double baseSize) =>
      ResponsiveHelper.getIconSize(context, baseSize);
  double elevation(double baseElevation) =>
      ResponsiveHelper.getElevation(context, baseElevation);
}

// Widget extensions for easier responsive development
extension ResponsiveWidget on Widget {
  Widget responsive({
    Widget? mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    return ResponsiveBuilder(
      builder: (context, info) {
        if (info.isDesktop && desktop != null) return desktop;
        if (info.isTablet && tablet != null) return tablet;
        if (mobile != null) return mobile;
        return this;
      },
    );
  }

  Widget paddingResponsive(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.getScreenPadding(context),
      child: this,
    );
  }

  Widget paddingHorizontalResponsive(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.getHorizontalPadding(context),
      child: this,
    );
  }
}
