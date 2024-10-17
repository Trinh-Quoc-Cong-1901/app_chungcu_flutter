import 'dart:async';
import 'package:ecogreen_city/components/app_colors/app_colors.dart';
import 'package:ecogreen_city/components/app_style/app_style.dart';
import 'package:ecogreen_city/screens/home/home_screen.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Chuyển sang màn hình chính sau 2 giây
    Timer(const Duration(seconds: 2), () {
      // sử dụng pushReplacement để bỏ trang hiện tại ra khoải stack vì thế sẽ không quay lại được.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen()), // Chuyển đến màn hình HomePage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final heightRatio = screenHeight / 706;
    final widthRatio = screenWidth / 340;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 230 * widthRatio,
              height: 230 * heightRatio,
              decoration: BoxDecoration(
                color: AppColors.backgroundSocialColor,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Center(
                child: Text(
                  "EcoGreen City",
                  style: AppStyles.baseTextStyle
                      .copyWith(fontSize: 30 * heightRatio),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
