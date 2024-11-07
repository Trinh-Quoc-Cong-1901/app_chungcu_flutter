import 'package:ecogreen_city/screens/home/home_screen.dart';
import 'package:ecogreen_city/screens/splash.dart/splash_screen.dart';

import 'package:flutter/material.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: const SplashScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(), // Màn hình chính
        '/home': (context) => const HomeScreen(), // Màn hình chính
        // '/movieDetail': (context) =>
        //     const MovieDetailScreen(), // Màn hình chi tiết phim
        // '/movie': (context) => const MovieScreen(), // Màn hình chi tiết phim
      }, // HomeScreen là trang gốc
    );
  }
}
