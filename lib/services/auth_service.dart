import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  // Lưu token và thông tin user
  Future<void> saveLoginData({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
    await _storage.write(key: 'userId', value: userId);
  }

  // Lấy Access Token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  // Lấy Refresh Token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  // Lấy User ID đã lưu
  Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
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
      final accessToken = responseData['accessToken'];
      final newRefreshToken = responseData['refreshToken'];
      final userId = await getUserId();

      await saveLoginData(
        accessToken: accessToken,
        refreshToken: newRefreshToken,
        userId: userId ?? '',
      );
    } else {
      throw Exception('Không thể làm mới token: ${response.reasonPhrase}');
    }
  }

  // Xóa thông tin đăng nhập
  Future<void> clearLoginData() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'userId');
  }
}
