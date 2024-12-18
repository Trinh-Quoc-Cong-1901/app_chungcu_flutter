import 'package:flutter/material.dart';

import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class CartScreen extends StatelessWidget {
  final List<dynamic> cartItems;
  final Map<dynamic, int> productQuantities;

  const CartScreen(
      {super.key, required this.cartItems, required this.productQuantities});

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(
      0.0,
      (sum, product) =>
          sum + (double.parse(product['price']) * productQuantities[product]!),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
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
                                'Giá: ${product['price']}đ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Số lượng: ${productQuantities[product]}',
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
                              onPressed: () {
                                if (productQuantities[product]! > 1) {
                                  productQuantities[product] =
                                      productQuantities[product]! - 1;
                                  (context as Element).markNeedsBuild();
                                }
                              },
                            ),
                            Text(
                              '${productQuantities[product]}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () {
                                productQuantities[product] =
                                    productQuantities[product]! + 1;
                                (context as Element).markNeedsBuild();
                              },
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
                  'Tổng cộng: $totalPriceđ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaypalCheckoutView(
                          sandboxMode: true,
                          clientId:
                              "AT-l0EYJL-UjnI8RsO_ebkRh-XpoTVBSCKGOfR0Q_JqW7O-cGUxxgrgibm8CDFE1eHccolNFWxH-wwAt", // Thay thế bằng Client ID từ PayPal Developer
                          secretKey:
                              "EK0JvKMHz8mRxTgu6TT4XQmZKgpcGt45kTRzS97TxMeVjgn0m1qpZ9bz7SuIvxIlaNGK7wUpvOYRLLjz",

                          transactions: [
                            {
                              "amount": {
                                "total": "$totalPrice",
                                "currency": "USD",
                                "details": {
                                  "subtotal": "$totalPrice",
                                  "shipping": "0",
                                  "handling_fee": "0",
                                  "tax": "0",
                                  "shipping_discount": "0"
                                }
                              },
                              "description": "Giỏ hàng của bạn",
                              "item_list": {
                                "items": cartItems.map((product) {
                                  return {
                                    "name": product['name'],
                                    "quantity": "${productQuantities[product]}",
                                    "price": product['price'],
                                    "currency": "USD"
                                  };
                                }).toList()
                              }
                            }
                          ],
                          onSuccess: (Map params) async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Thanh toán thành công!')),
                            );
                          },
                          onError: (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Có lỗi xảy ra trong quá trình thanh toán.')),
                            );
                          },
                          onCancel: (params) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Thanh toán đã bị huỷ.')),
                            );
                          },
                        ),
                      ),
                    );
                  },
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
