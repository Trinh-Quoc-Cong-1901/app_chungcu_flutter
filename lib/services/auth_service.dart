// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;

// class AuthService {
//   final _storage = const FlutterSecureStorage();

//   // Lưu token
//   Future<void> saveToken(String accessToken, String refreshToken) async {
//     await _storage.write(key: 'accessToken', value: accessToken);
//     await _storage.write(key: 'refreshToken', value: refreshToken);
//   }

//   // Lấy Access Token
//   Future<String?> getAccessToken() async {
//     return await _storage.read(key: 'accessToken');
//   }

//   // Xóa token
//   Future<void> clearToken() async {
//     await _storage.delete(key: 'accessToken');
//     await _storage.delete(key: 'refreshToken');
//   }

//   // Làm mới token
//   Future<void> refreshToken() async {
//     final refreshToken = await _storage.read(key: 'refreshToken');
//     if (refreshToken == null) {
//       throw Exception('Refresh token không tồn tại.');
//     }

//     final response = await http.post(
//       Uri.parse('http://localhost:3000/api/token/refresh'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'refreshToken': refreshToken}),
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       await saveToken(
//           responseData['accessToken'], responseData['refreshToken']);
//     } else {
//       throw Exception('Failed to refresh token.');
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _storage = const FlutterSecureStorage();

  // Lưu token và userId
  Future<void> saveLoginData({
    required String accessToken,
    required String refreshToken,
    required String user,
  }) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
    await _storage.write(key: 'user', value: user);
  }

  // Lấy Access Token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  // Lấy Refresh Token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  // Lấy User ID
  Future<String?> getUser() async {
    return await _storage.read(key: 'user');
  }

  // Xóa thông tin đăng nhập
  Future<void> clearLoginData() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'user');
  }

  // Làm mới token
  Future<void> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw Exception('Refresh token không tồn tại.');
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/token/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      await saveLoginData(
        accessToken: responseData['accessToken'],
        refreshToken: responseData['refreshToken'],
        user: await getUser() ?? '', // Giữ lại userId cũ nếu có
      );
    } else {
      throw Exception('Failed to refresh token.');
    }
  }
}
