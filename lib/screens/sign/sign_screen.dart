// import 'package:ecogreen_city/components/app_colors/app_colors.dart';
// import 'package:ecogreen_city/components/app_style/app_style.dart';
// import 'package:ecogreen_city/components/custom_button/custom_button.dart';
// import 'package:ecogreen_city/components/custom_button/custom_social.dart';
// import 'package:ecogreen_city/components/custom_button/custom_textfield.dart';
// import 'package:ecogreen_city/screens/home/home_screen.dart';
// import 'package:flutter/material.dart';

// class SignInScreen extends StatefulWidget {
//   final String? email;
//   final String? password;

//   const SignInScreen({super.key, this.email, this.password});

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   late TextEditingController _emailController;
//   late TextEditingController _passwordController;

//   String? _errorText;

//   // Hàm kiểm tra định dạng email
//   bool _isValidEmail(String email) {
//     final emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
//     return emailRegex.hasMatch(email);
//   }

//   // Hàm xử lý khi người dùng thay đổi nội dung TextField
//   void _handleEmailChange(String value) {
//     setState(() {
//       if (value.isEmpty) {
//         _errorText = null; // Không hiển thị lỗi khi trường trống
//       } else if (_isValidEmail(value)) {
//         _errorText = null; // Email đúng
//       } else {
//         _errorText = 'Email invalid'; // Email sai
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Khởi tạo giá trị cho TextEditingController từ dữ liệu truyền vào
//     _emailController = TextEditingController(text: widget.email);
//     _passwordController = TextEditingController(text: widget.password);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final heightRatio = screenHeight / 706;
//     final widthRatio = screenWidth / 340;
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.only(
//                   left: 17 * widthRatio,
//                   top: 49 * heightRatio,
//                   right: 30 * widthRatio,
//                   bottom: 30 * heightRatio),
//               // Khoảng cách dưới cùng
//               child: Text(
//                 'Sign In',
//                 style: AppStyles.baseTextStyle
//                     .copyWith(fontSize: 35 * heightRatio),
//               ),
//             ),

//             SizedBox(height: 10 * heightRatio),

//             // Container chứa email và password
//             Container(
//               height: 321 * heightRatio,
//               padding: EdgeInsets.only(
//                   left: 17 * widthRatio,
//                   // top: screenHeight * 25 / 706,
//                   right: 30 * heightRatio),
//               // Điều chỉnh padding bên trong container
//               decoration: const BoxDecoration(
//                 color: AppColors.whiteColor,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ), // Bo góc
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Email TextField
//                   SizedBox(height: 25 * heightRatio),

//                   CustomTextField2(
//                     height: heightRatio * 58,
//                     controller: _emailController,
//                     labelText: 'Email',
//                     hintText: 'Email',
//                     iconRight: Image.asset(
//                       'assets/images/icon_email.png',
//                       scale: 2,
//                     ),
//                     onChanged: _handleEmailChange,
//                     errorText: _errorText,
//                   ),
//                   SizedBox(height: 29 * heightRatio),

//                   // Password TextField
//                   CustomTextField2(
//                     height: heightRatio * 58,

//                     controller: _passwordController,
//                     labelText: 'Password',
//                     hintText: 'Password',
//                     // iconLeft: Icons.lock,
//                     isPassword: true,
//                   ),

//                   // Forgot Password
//                   SizedBox(height: 10 * heightRatio),

//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Forgot password?",
//                         style: AppStyles.baseTextStyle.copyWith(
//                             fontSize: 12 * heightRatio,
//                             color: AppColors.blackColor),
//                       ),
//                     ),
//                   ),

//                   // Sign In Button
//                   SizedBox(height: 33 * heightRatio),
//                   Center(
//                     child: CustomButton(
//                       // width: double.infinity,
//                       height: 58 * heightRatio,
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text('Success'),
//                               content:
//                                   const Text('Bạn đã đăng nhập thành công!'),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context)
//                                         .pop(); // Đóng dialog trước
//                                     // Sử dụng Future.delayed để đợi việc đóng dialog hoàn tất
//                                     Future.delayed(
//                                         const Duration(milliseconds: 100), () {
//                                       // Chuyển sang màn hình Home
//                                       Navigator.pushReplacement(
//                                         // ignore: use_build_context_synchronously
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const HomeScreen()),
//                                       );
//                                     });
//                                   },
//                                   child: const Text('OK'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },

//                       enable: true,
//                       child: Text(
//                         'Sign In',
//                         style: AppStyles.baseTextStyle.copyWith(
//                           fontSize: 18 * heightRatio,
//                           color: AppColors.whiteColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             Container(
//               width: double.infinity,
//               height: 190 * heightRatio, // Đặt chiều rộng là toàn bộ màn hình
//               padding: EdgeInsets.only(
//                   left: 17 * widthRatio,
//                   top: 22 * heightRatio,
//                   right: 30 * widthRatio), // Điều chỉnh padding
//               decoration: const BoxDecoration(
//                 color: AppColors.backgroundSocialColor, // Màu nền cho container
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Custom Google Button
//                   CustomSocialButton(
//                     icon: Image.asset(
//                       'assets/images/icon_google.png',
//                       width: screenWidth * 28 / 304,
//                       height: screenHeight * 28 / 706,
//                     ),
//                     // iconColor: Color(0xFF0000),
//                     text: 'Continue with Google',
//                     onPressed: () {
//                       // Handle Google Sign In
//                     },
//                   ),
//                   SizedBox(height: 30 * heightRatio),

//                   // Custom Facebook Button
//                   CustomSocialButton(
//                     icon: Image.asset(
//                       'assets/images/icon_facebook.png',
//                       width: screenWidth * 28 / 304,
//                       height: screenHeight * 28 / 706,
//                     ),
//                     // iconColor: Colors.blue,
//                     text: 'Continue with Facebook',
//                     onPressed: () {
//                       // Handle Facebook Sign In
//                     },
//                   ),
//                   // SizedBox(height: screenHeight * 40 / 706),
//                 ],
//               ),
//             ),

//             // Khoảng cách phía dưới cùng
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ecogreen_city/components/app_colors/app_colors.dart';
import 'package:ecogreen_city/components/app_style/app_style.dart';
import 'package:ecogreen_city/components/custom_button/custom_button.dart';
// import 'package:ecogreen_city/components/custom_button/custom_social.dart';
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
  bool _isLoading = false; // Thêm biến để hiển thị loading

  // Hàm kiểm tra định dạng email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(email);
  }

  // Hàm xử lý khi người dùng thay đổi nội dung TextField
  void _handleEmailChange(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorText = null; // Không hiển thị lỗi khi trường trống
      } else if (_isValidEmail(value)) {
        _errorText = null; // Email đúng
      } else {
        _errorText = 'Email invalid'; // Email sai
      }
    });
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
      _errorText = null; // Xóa thông báo lỗi cũ
    });

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:3000/api/token/login'), // Thay URL bằng URL thực tế
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Đăng nhập thành công, lưu token hoặc thực hiện hành động khác

        // Chuyển sang màn hình Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Hiển thị lỗi từ API
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
  void initState() {
    super.initState();
    // Khởi tạo giá trị cho TextEditingController từ dữ liệu truyền vào
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
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
            // Tiêu đề Sign In
            Container(
              padding: EdgeInsets.only(
                  left: 17 * widthRatio,
                  top: 49 * heightRatio,
                  right: 30 * widthRatio,
                  bottom: 30 * heightRatio),
              child: Text(
                'Sign In',
                style: AppStyles.baseTextStyle
                    .copyWith(fontSize: 35 * heightRatio),
              ),
            ),

            SizedBox(height: 10 * heightRatio),

            // Container chứa email và password
            Container(
              height: 321 * heightRatio,
              padding: EdgeInsets.only(
                  left: 17 * widthRatio, right: 30 * heightRatio),
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

                  // Email TextField
                  CustomTextField2(
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
                  ),
                  SizedBox(height: 29 * heightRatio),

                  // Password TextField
                  CustomTextField2(
                    height: heightRatio * 58,
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Password',
                    isPassword: true,
                  ),

                  // Forgot Password
                  SizedBox(height: 10 * heightRatio),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot password?",
                        style: AppStyles.baseTextStyle.copyWith(
                            fontSize: 12 * heightRatio,
                            color: AppColors.blackColor),
                      ),
                    ),
                  ),

                  // Sign In Button
                  SizedBox(height: 33 * heightRatio),
                  Center(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
