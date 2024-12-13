

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecogreen_city/components/app_colors/app_colors.dart';
import 'package:ecogreen_city/components/app_style/app_style.dart';
import 'package:ecogreen_city/components/custom_button/custom_button.dart';
import 'package:ecogreen_city/components/custom_button/custom_textfield.dart';
import 'package:ecogreen_city/screens/home/home_screen.dart';

class SignInScreen extends StatefulWidget {
  final String? email;
  final String? password;

  const SignInScreen({super.key, this.email, this.password});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  String? _errorText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
  }

  // Hàm kiểm tra định dạng email
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  // Hàm xử lý khi người dùng thay đổi nội dung TextField
  void _handleEmailChange(String value) {
    setState(() {
      _errorText = value.isEmpty
          ? null
          : (_isValidEmail(value) ? null : 'Email invalid');
    });
  }

  // Hàm lưu thông tin người dùng vào SharedPreferences
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userData['userId']);
    await prefs.setString('name', userData['name']);
    await prefs.setString('email', userData['email']);
    await prefs.setString('token', userData['token']);
    await prefs.setString('role', userData['role']);
  }

  // Hàm gọi API đăng nhập
  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = 'Email và mật khẩu không được để trống';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/token/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Lưu thông tin người dùng
        await _saveUserData({
          'userId': responseData['user']['id'],
          'name': responseData['user']['name'],
          'email': responseData['user']['email'],
          'token': responseData['accessToken'],
          'role': responseData['user']['role'],
        });

        // Chuyển sang màn hình Home
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        final responseData = jsonDecode(response.body);
        setState(() {
          _errorText = responseData['message'];
        });
      }
    } catch (error) {
      setState(() {
        _errorText = 'Có lỗi xảy ra. Vui lòng thử lại sau.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final heightRatio = screenHeight / 706;
    final widthRatio = screenWidth / 340;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(widthRatio, heightRatio),
            SizedBox(height: 10 * heightRatio),
            _buildForm(widthRatio, heightRatio),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double widthRatio, double heightRatio) {
    return Container(
      padding: EdgeInsets.only(
        left: 17 * widthRatio,
        top: 49 * heightRatio,
        right: 30 * widthRatio,
        bottom: 30 * heightRatio,
      ),
      child: Text(
        'Sign In',
        style: AppStyles.baseTextStyle.copyWith(fontSize: 35 * heightRatio),
      ),
    );
  }

  Widget _buildForm(double widthRatio, double heightRatio) {
    return Container(
      height: 321 * heightRatio,
      padding: EdgeInsets.symmetric(
        horizontal: 17 * widthRatio,
      ),
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25 * heightRatio),
          _buildEmailField(heightRatio),
          SizedBox(height: 29 * heightRatio),
          _buildPasswordField(heightRatio),
          _buildForgotPassword(heightRatio),
          SizedBox(height: 33 * heightRatio),
          _buildSignInButton(heightRatio),
        ],
      ),
    );
  }

  Widget _buildEmailField(double heightRatio) {
    return CustomTextField2(
      height: heightRatio * 58,
      controller: _emailController,
      labelText: 'Email',
      hintText: 'Email',
      iconRight: Image.asset(
        'assets/images/icon_email.png',
        scale: 2,
      ),
      onChanged: _handleEmailChange,
      errorText: _errorText,
    );
  }

  Widget _buildPasswordField(double heightRatio) {
    return CustomTextField2(
      height: heightRatio * 58,
      controller: _passwordController,
      labelText: 'Password',
      hintText: 'Password',
      isPassword: true,
    );
  }

  Widget _buildForgotPassword(double heightRatio) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          "Forgot password?",
          style: AppStyles.baseTextStyle.copyWith(
            fontSize: 12 * heightRatio,
            color: AppColors.blackColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(double heightRatio) {
    return Center(
      child: CustomButton(
        height: 58 * heightRatio,
        onTap: _isLoading ? null : _signIn,
        enable: true,
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
                'Sign In',
                style: AppStyles.baseTextStyle.copyWith(
                  fontSize: 18 * heightRatio,
                  color: AppColors.whiteColor,
                ),
              ),
      ),
    );
  }
}
