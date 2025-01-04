import 'dart:convert';
import 'package:ecogreen_city/components/app_colors/app_colors.dart';
import 'package:ecogreen_city/components/app_style/app_style.dart';
import 'package:ecogreen_city/components/custom_button/custom_button.dart';
import 'package:ecogreen_city/components/custom_button/custom_textfield.dart';
import 'package:ecogreen_city/screens/home/home_screen.dart';
import 'package:ecogreen_city/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String? _errorText;
  bool _isLoading = false;

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = 'Email và mật khẩu không được để trống.';
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

        // Lưu token và thông tin người dùng qua AuthService
        await _authService.saveLoginData(
          accessToken: responseData['accessToken'],
          refreshToken: responseData['refreshToken'],
          userId: responseData['user']['id'],
        );

        // Chuyển đến HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        final responseData = jsonDecode(response.body);
        setState(() {
          _errorText = responseData['message'];
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'Đã xảy ra lỗi. Vui lòng thử lại.';
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
            if (_errorText != null)
              Padding(
                padding: EdgeInsets.all(16 * widthRatio),
                child: Text(
                  _errorText!,
                  style:
                      TextStyle(color: Colors.red, fontSize: 14 * heightRatio),
                ),
              ),
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
      height: 360 * heightRatio,
      padding: EdgeInsets.symmetric(horizontal: 17 * widthRatio),
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
          SizedBox(height: 20 * heightRatio),
          _buildPasswordField(heightRatio),
          SizedBox(height: 15 * heightRatio),
          _buildForgotPassword(heightRatio),
          SizedBox(height: 30 * heightRatio),
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
      hintText: 'Nhập email của bạn',
      iconRight: Image.asset(
        'assets/images/icon_email.png',
        scale: 2,
      ),
      onChanged: (value) {
        setState(() {
          _errorText = value.isEmpty
              ? null
              : (_isValidEmail(value) ? null : 'Email không hợp lệ');
        });
      },
    );
  }

  Widget _buildPasswordField(double heightRatio) {
    return CustomTextField2(
      height: heightRatio * 58,
      controller: _passwordController,
      labelText: 'Password',
      hintText: 'Nhập mật khẩu của bạn',
      isPassword: true,
    );
  }

  Widget _buildForgotPassword(double heightRatio) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Logic quên mật khẩu
        },
        child: Text(
          'Quên mật khẩu?',
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
        enable: !_isLoading,
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
                'Đăng Nhập',
                style: AppStyles.baseTextStyle.copyWith(
                  fontSize: 18 * heightRatio,
                  color: AppColors.whiteColor,
                ),
              ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+$').hasMatch(email);
  }
}
