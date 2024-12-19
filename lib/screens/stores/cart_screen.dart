// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
// import 'package:http/http.dart' as http;

// class CartScreen extends StatefulWidget {
//   final List<dynamic> cartItems;
//   final Map<dynamic, int> productQuantities;

//   const CartScreen(
//       {super.key, required this.cartItems, required this.productQuantities});

//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   double calculateTotal() {
//     if (widget.cartItems.isEmpty || widget.productQuantities.isEmpty) {
//       return 0.0;
//     }

//     return widget.cartItems.fold(0.0, (sum, product) {
//       double price = double.tryParse(product['price'] ?? '0') ?? 0.0;
//       int quantity = widget.productQuantities[product] ?? 0;
//       return sum + (price * quantity);
//     });
//   }

//   void increaseQuantity(dynamic product) {
//     setState(() {
//       widget.productQuantities[product] =
//           (widget.productQuantities[product] ?? 0) + 1;
//     });
//   }

//   void decreaseQuantity(dynamic product) {
//     setState(() {
//       if ((widget.productQuantities[product] ?? 0) > 1) {
//         widget.productQuantities[product] =
//             (widget.productQuantities[product] ?? 1) - 1;
//       }
//     });
//   }

//   void removeProduct(dynamic product) {
//     setState(() {
//       widget.productQuantities.remove(product);
//     });
//   }

//   Future<void> _createOrderInAPI(double totalAmount) async {
//     // Tạo JSON cho đơn hàng
//     String orderId = DateTime.now().millisecondsSinceEpoch.toString();
//     List<Map<String, dynamic>> products = widget.cartItems.map((product) {
//       return {
//         'name': product['name'] ?? 'Unknown',
//         'quantity': widget.productQuantities[product] ?? 0,
//         'price': double.tryParse(product['price'] ?? '0') ?? 0.0,
//       };
//     }).toList();

//     Map<String, dynamic> orderData = {
//       'orderId': orderId,
//       'products': products,
//       'totalAmount': totalAmount,
//     };

//     // Gửi yêu cầu POST tới API
//     try {
//       final response = await http.post(
//         Uri.parse('http://localhost:3000/api/orders'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(orderData),
//       );

//       if (response.statusCode == 201) {
//         log("Order created successfully: ${response.body}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Hóa đơn đã được lưu vào hệ thống')),
//         );
//       } else {
//         log("Failed to create order: ${response.statusCode}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Lỗi khi tạo hóa đơn: ${response.body}')),
//         );
//       }
//     } catch (e) {
//       log("Error creating order: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Không thể kết nối tới hệ thống API')),
//       );
//     }
//   }

//   void _startPayPalPayment() {
//     double totalAmount = calculateTotal();

//     if (totalAmount == 0.0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Giỏ hàng trống hoặc không hợp lệ')),
//       );
//       return;
//     }

//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (BuildContext context) => PaypalCheckoutView(
//         sandboxMode: true,
//         clientId:
//             "AT-l0EYJL-UjnI8RsO_ebkRh-XpoTVBSCKGOfR0Q_JqW7O-cGUxxgrgibm8CDFE1eHccolNFWxH-wwAt", // Thay thế bằng Client ID
//         secretKey:
//             "EK0JvKMHz8mRxTgu6TT4XQmZKgpcGt45kTRzS97TxMeVjgn0m1qpZ9bz7SuIvxIlaNGK7wUpvOYRLLjz", // Thay thế bằng Secret Key
//         transactions: [
//           {
//             "amount": {
//               "total": totalAmount.toStringAsFixed(2),
//               "currency": "USD",
//               "details": {
//                 "subtotal": totalAmount.toStringAsFixed(2),
//                 "shipping": "0",
//                 "shipping_discount": "0"
//               }
//             },
//             "description": "Thanh toán giỏ hàng",
//             "item_list": {
//               "items": widget.cartItems.map((product) {
//                 double price = double.tryParse(product['price'] ?? '0') ?? 0.0;
//                 return {
//                   "name": product['name'] ?? 'Sản phẩm không xác định',
//                   "quantity": "${widget.productQuantities[product] ?? 0}",
//                   "price": price.toStringAsFixed(2),
//                   "currency": "USD"
//                 };
//               }).toList(),
//             }
//           }
//         ],
//         note: "Liên hệ với chúng tôi nếu có thắc mắc về đơn hàng.",
//         onSuccess: (Map params) async {
//           log("onSuccess: $params");
//           await _createOrderInAPI(totalAmount); // Tạo hóa đơn trong API
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Thanh toán thành công')),
//           );
//           setState(() {
//             widget.productQuantities.clear(); // Xóa giỏ hàng
//           });
//           Navigator.pop(context);
//         },
//         onError: (error) {
//           log("onError: $error");
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Có lỗi xảy ra: $error')),
//           );
//         },
//         onCancel: () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Thanh toán đã bị hủy')),
//           );
//         },
//       ),
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     double totalPrice = calculateTotal();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Giỏ hàng'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: widget.cartItems.length,
//               itemBuilder: (context, index) {
//                 final product = widget.cartItems[index];
//                 final quantity = widget.productQuantities[product] ?? 0;
//                 double price = double.tryParse(product['price'] ?? '0') ?? 0.0;

//                 return Card(
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Row(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.network(
//                             product['imageUrl'] ??
//                                 'https://via.placeholder.com/150',
//                             width: 80,
//                             height: 80,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 product['name'] ?? 'Không có tên sản phẩm',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 'Giá: ${price.toStringAsFixed(2)} USD',
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.orange,
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 'Tổng: ${(price * quantity).toStringAsFixed(2)} USD',
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.remove, color: Colors.red),
//                               onPressed: () => decreaseQuantity(product),
//                             ),
//                             Text('$quantity',
//                                 style: const TextStyle(fontSize: 16)),
//                             IconButton(
//                               icon: const Icon(Icons.add, color: Colors.green),
//                               onPressed: () => increaseQuantity(product),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Tổng cộng: $totalPrice USD',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _startPayPalPayment,
//                   child: const Text('Thanh toán qua PayPal'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:ecogreen_city/screens/account/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  final List<dynamic> cartItems;
  final Map<dynamic, int> productQuantities;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.productQuantities,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  /// Tính tổng số tiền trong giỏ hàng
  double calculateTotal() {
    if (widget.cartItems.isEmpty || widget.productQuantities.isEmpty) {
      return 0.0;
    }

    return widget.cartItems.fold(0.0, (sum, product) {
      double price = double.tryParse(product['price'] ?? '0') ?? 0.0;
      int quantity = widget.productQuantities[product] ?? 0;
      return sum + (price * quantity);
    });
  }

  /// Tăng số lượng sản phẩm
  void increaseQuantity(dynamic product) {
    setState(() {
      widget.productQuantities[product] =
          (widget.productQuantities[product] ?? 0) + 1;
    });
  }

  /// Giảm số lượng sản phẩm
  void decreaseQuantity(dynamic product) {
    setState(() {
      if ((widget.productQuantities[product] ?? 0) > 1) {
        widget.productQuantities[product] =
            (widget.productQuantities[product] ?? 1) - 1;
      }
    });
  }

  /// Xóa sản phẩm khỏi giỏ hàng
  void removeProduct(dynamic product) {
    setState(() {
      widget.productQuantities.remove(product);
    });
  }

  /// Tạo hóa đơn trên API
  Future<void> _createOrderInAPI(double totalAmount) async {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    List<Map<String, dynamic>> products = widget.cartItems.map((product) {
      return {
        'name': product['name'] ?? 'Unknown',
        'quantity': widget.productQuantities[product] ?? 0,
        'price': double.tryParse(product['price'] ?? '0') ?? 0.0,
        'image': product['imageUrl'] ?? 'https://via.placeholder.com/150',
      };
    }).toList();

    Map<String, dynamic> orderData = {
      'orderId': orderId,
      'products': products,
      'totalAmount': totalAmount,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        log("Order created successfully: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hóa đơn đã được lưu vào hệ thống')),
        );
      } else {
        log("Failed to create order: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tạo hóa đơn: ${response.body}')),
        );
      }
    } catch (e) {
      log("Error creating order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể kết nối tới hệ thống API')),
      );
    }
  }

  /// Bắt đầu thanh toán qua PayPal
  void _startPayPalPayment() {
    double totalAmount = calculateTotal();

    if (totalAmount == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giỏ hàng trống hoặc không hợp lệ')),
      );
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId:
            "AT-l0EYJL-UjnI8RsO_ebkRh-XpoTVBSCKGOfR0Q_JqW7O-cGUxxgrgibm8CDFE1eHccolNFWxH-wwAt",
        secretKey:
            "EK0JvKMHz8mRxTgu6TT4XQmZKgpcGt45kTRzS97TxMeVjgn0m1qpZ9bz7SuIvxIlaNGK7wUpvOYRLLjz",
        transactions: [
          {
            "amount": {
              "total": totalAmount.toStringAsFixed(2),
              "currency": "USD",
              "details": {
                "subtotal": totalAmount.toStringAsFixed(2),
                "shipping": "0",
                "shipping_discount": "0"
              }
            },
            "description": "Thanh toán giỏ hàng",
            "item_list": {
              "items": widget.cartItems.map((product) {
                double price = double.tryParse(product['price'] ?? '0') ?? 0.0;
                return {
                  "name": product['name'] ?? 'Sản phẩm không xác định',
                  "quantity": "${widget.productQuantities[product] ?? 0}",
                  "price": price.toStringAsFixed(2),
                  "currency": "USD"
                };
              }).toList(),
            }
          }
        ],
        note: "Liên hệ với chúng tôi nếu có thắc mắc về đơn hàng.",
        onSuccess: (Map params) async {
          log("onSuccess: $params");
          await _createOrderInAPI(totalAmount);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thanh toán thành công')),
          );
          setState(() {
            widget.productQuantities.clear();
          });
          Navigator.pop(context);
        },
        onError: (error) {
          log("onError: $error");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Có lỗi xảy ra: $error')),
          );
        },
        onCancel: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thanh toán đã bị hủy')),
          );
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt), // Icon biểu tượng danh sách
            tooltip: 'Xem đơn hàng',
            onPressed: () {
              // Chuyển màn hình đến màn hình đơn hàng
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => OrderScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final product = widget.cartItems[index];
                final quantity = widget.productQuantities[product] ?? 0;
                double price = double.tryParse(product['price'] ?? '0') ?? 0.0;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product['imageUrl'] ??
                                'https://via.placeholder.com/150',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'] ?? 'Không có tên sản phẩm',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Giá: ${price.toStringAsFixed(2)} USD',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Tổng: ${(price * quantity).toStringAsFixed(2)} USD',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () => decreaseQuantity(product),
                            ),
                            Text('$quantity',
                                style: const TextStyle(fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () => increaseQuantity(product),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng cộng: $totalPrice USD',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _startPayPalPayment,
                  child: const Text('Thanh toán qua PayPal'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
