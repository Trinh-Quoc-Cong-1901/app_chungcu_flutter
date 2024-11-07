import 'package:ecogreen_city/components/app_colors/app_colors.dart';

import 'package:flutter/material.dart';

class CustomTextField2 extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final String? errorText;
  final Widget? iconRight; // iconRight được khai báo là Widget
  final bool isPassword;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final IconData? iconLeft;
  final double? width; // Thêm thuộc tính width
  final double? height; // Thêm thuộc tính height

  const CustomTextField2({
    super.key,
    this.controller,
    required this.labelText,
    required this.hintText,
    this.errorText,
    this.iconRight,
    this.iconLeft,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.isPassword = false,
    this.width,
    this.height,
  });

  @override
  State<CustomTextField2> createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText =
        widget.isPassword; // Set trạng thái ban đầu cho trường mật khẩu
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final heightRatio = screenHeight / 706;
    final widthRatio = screenWidth / 340;
    return SizedBox(
      width: widget.width, // Sử dụng width từ widget
      height: widget.height, // Sử dụng height từ widget
      child: TextField(
        obscureText: widget.isPassword ? _obscureText : false,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.backgroundTextColor,
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            color: AppColors.hintTextColor, // Đặt màu cho labelText
            fontSize: 18, // Có thể giữ cố định kích thước chữ
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color:
                // ignore: deprecated_member_use
                AppColors.blackColor.withOpacity(0.35), // Đặt màu cho labelText
            fontSize: 21 * heightRatio, // Có thể giữ cố định kích thước chữ
          ),
          errorText: widget.errorText,
          suffixIcon: widget.isPassword
              ? SizedBox(
                  width: 24 * widthRatio, // Đặt chiều rộng của icon
                  height: 24 * heightRatio, // Đặt chiều cao của icon
                  child: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      size: 20, // Đặt kích thước icon
                    ),
                    onPressed: _toggleVisibility,
                  ),
                )
              : SizedBox(
                  width: 10 * widthRatio, // Đặt chiều rộng cho icon khác
                  height: 10 * heightRatio, // Đặt chiều cao cho icon khác
                  child: widget.iconRight,
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
