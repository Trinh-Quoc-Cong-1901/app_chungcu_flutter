import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecogreen_city/providers/auth_provider.dart';
import 'package:ecogreen_city/screens/splash.dart/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        // Thêm các route khác nếu cần
      },
    );
  }
}
