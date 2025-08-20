import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/theme.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'WhatsApp Clone',
          debugShowCheckedModeBanner: false,
          theme: WhatsAppTheme.lightTheme,
          darkTheme: WhatsAppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
