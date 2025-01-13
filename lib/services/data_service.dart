import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecogreen_city/services/auth_service.dart';

class DataService {
  final AuthService _authService = AuthService();

  Future<List<dynamic>> loadNotifications() async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Access token không tồn tại.');
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.4:3000/api/notifications/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await _authService.refreshToken();
      return loadNotifications(); // Thử lại
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Access token không tồn tại.');
    }

    final response = await http.put(
      Uri.parse(
          'http://192.168.1.4:3000/api/notifications/$notificationId/read'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'isRead': true}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update notification: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> loadFeedbacks() async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.4:3000/api/feedbacks/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await _authService.refreshToken();
      return loadFeedbacks(); // Thử lại
    } else {
      throw Exception('Failed to load feedbacks');
    }
  }

  Future<List<dynamic>> loadStores() async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.4:3000/api/stores/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await _authService.refreshToken();
      return loadStores(); // Thử lại
    } else {
      throw Exception('Failed to load stores');
    }
  }

  Future<List<dynamic>> loadFeeds() async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.4:3000/api/posts/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await _authService.refreshToken();
      return loadFeeds(); // Thử lại
    } else {
      throw Exception('Failed to load feeds');
    }
  }

  Future<List<dynamic>> loadFeedDetail(feedID) async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.4:3000/api/posts/$feedID'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await _authService.refreshToken();
      return loadFeeds(); // Thử lại
    } else {
      throw Exception('Failed to load feeds');
    }
  }

  Future<List<dynamic>> loadBills() async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.4:3000/api/invoices/user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await _authService.refreshToken();
      return loadBills(); // Thử lại
    } else {
      throw Exception('Failed to load bills');
    }
  }

  // Thêm bài viết yêu thích
  Future<void> likePost(String postId) async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.post(
      Uri.parse('http://192.168.1.4:3000/api/posts/$postId/like'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like post');
    }
  }

  // Thêm bình luận vào bài viết
  Future<void> addComment(String postId, String content) async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.post(
      Uri.parse('http://192.168.1.4:3000/api/posts/$postId/comment'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'content': content}),
    );
    print(response.statusCode);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add comment');
    }
  }

// order
  Future<List<dynamic>> loadOrders() async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.4:3000/api/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await _authService.refreshToken();
      return loadOrders(); // Thử lại
    } else {
      throw Exception('Failed to load orders');
    }
  }

  //member
  // Lấy thông tin người dùng
  Future<Map<String, dynamic>> fetchUserData() async {
    final userId = await _authService.getUserId();
    if (userId == null) throw Exception('Không thể lấy thông tin userId.');

    final response = await http.get(
      Uri.parse('http://192.168.1.4:3000/api/users/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Không thể tải thông tin người dùng: ${response.reasonPhrase}');
    }
  }

  // Thêm thành viên
  Future<void> addMember(String name, int age, String relation) async {
    final userId = await _authService.getUserId();
    if (userId == null)
      throw Exception('Không thể thêm thành viên, User ID không tồn tại.');

    final response = await http.post(
      Uri.parse('http://192.168.1.4:3000/api/members/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"name": name, "age": age, "relation": relation}),
    );

    if (response.statusCode != 201) {
      throw Exception('Không thể thêm thành viên: ${response.reasonPhrase}');
    }
  }

  // Xóa thành viên
  Future<void> deleteMember(String memberId) async {
    final userId = await _authService.getUserId();
    if (userId == null)
      throw Exception('Không thể xóa thành viên, User ID không tồn tại.');

    final response = await http.delete(
      Uri.parse('http://192.168.1.4:3000/api/members/$userId/$memberId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Không thể xóa thành viên: ${response.reasonPhrase}');
    }
  }
  //chat

  // API lấy danh sách tin nhắn giữa user và admin
  Future<List<dynamic>> getChats() async {
    final token = await _authService.getAccessToken();
    if (token == null) throw Exception('Token không tồn tại.');

    final response = await http.get(
      Uri.parse('http://192.168.1.4:3000/api/chats/user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await _authService.refreshToken();
      return getChats(); // Thử lại nếu token hết hạn
    } else {
      throw Exception(
          'Không thể tải danh sách tin nhắn: ${response.reasonPhrase}');
    }
  }

  // API gửi tin nhắn từ user đến admin
  Future<void> sendMessageToAdmin(String messageContent) async {
    final token = await _authService.getAccessToken();
    if (token == null) throw Exception('Token không tồn tại.');

    const String receiverId =
        "6772d520283504d8284faf56"; // ID cố định của admin

    final messageData = {
      'receiverId': receiverId,
      'message': messageContent,
    };

    final response = await http.post(
      Uri.parse('http://192.168.1.4:3000/api/chats'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(messageData),
    );

    if (response.statusCode != 201) {
      throw Exception('Không thể gửi tin nhắn: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> getInvoiceDetails(String invoiceId) async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.4:3000/api/invoices/user/$invoiceId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await _authService.refreshToken();
      return getInvoiceDetails(invoiceId); // Thử lại
    } else {
      throw Exception('Không thể tải chi tiết hóa đơn: ${response.statusCode}');
    }
  }

  /// Lấy chi tiết đơn hàng
  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.4:3000/api/orders/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await _authService.refreshToken();
      return getOrderDetails(orderId); // Thử lại nếu token hết hạn
    } else {
      throw Exception(
          'Không thể tải chi tiết đơn hàng: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getRequestDetails(String feedbackId) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.4:3000/api/feedbacks/$feedbackId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Không thể tải chi tiết phản ánh: ${response.statusCode}');
    }
  }
}
//chat
