import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enable;
  final Color enabledBackgroundColor;
  final Color disabledBackgroundColor;

  final double? width;
  final double? height;

  // ignore: use_super_parameters
  const CustomButton({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.onTap,
    this.enable = true,
    this.enabledBackgroundColor = const Color(0xFFFFB900),
    this.disabledBackgroundColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    // final heightRatio = screenHeight / 706;
    // final widthRatio = screenWidth / 340;
    return GestureDetector(
      onTap: enable ? onTap : null,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: enable ? enabledBackgroundColor : disabledBackgroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: enable
              ? [
                  const BoxShadow(
                    // ignore: deprecated_member_use

                    color: Color(0x66000000), // Màu #00000040 với độ mờ 25%
                    offset: Offset(0, 4), // Vị trí bóng (0px, 4px)
                    blurRadius: 4, // Độ mờ của bóng
                    spreadRadius: 0, // Không có sự lan rộng của bóng
                  ),
                ]
              : [],
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
