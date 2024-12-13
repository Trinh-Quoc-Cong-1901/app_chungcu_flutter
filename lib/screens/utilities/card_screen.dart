import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:ecogreen_city/screens/utilities/model/product_model.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cartProducts;

  const CartScreen({super.key, required this.cartProducts});

  @override
  // ignore: library_private_types_in_public_api
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Map<Product, int> productQuantities; // Lưu số lượng sản phẩm

  @override
  void initState() {
    super.initState();
    productQuantities = {for (var product in widget.cartProducts) product: 1};
  }

  void increaseQuantity(Product product) {
    setState(() {
      productQuantities[product] = productQuantities[product]! + 1;
    });
  }

  void decreaseQuantity(Product product) {
    setState(() {
      if (productQuantities[product]! > 1) {
        productQuantities[product] = productQuantities[product]! - 1;
      }
    });
  }

  void removeProduct(Product product) {
    setState(() {
      productQuantities.remove(product);
    });
  }

  double calculateProductTotal(Product product) {
    return double.parse(product.priceSale) * productQuantities[product]!;
  }

  double calculateTotal() {
    return productQuantities.entries
        .map((entry) => double.parse(entry.key.priceSale) * entry.value)
        .reduce((a, b) => a + b);
  }

  double calculateTotalInUSD() {
    const double exchangeRate = 24000; // Tỷ giá: 1 USD = 24,000 VNĐ
    double totalInVND = calculateTotal();
    return totalInVND / exchangeRate; // Chuyển đổi sang USD
  }

  void _startPayPalPayment() {
    double totalAmountUSD = calculateTotalInUSD();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true, // Đổi thành false khi triển khai thực tế
        clientId:
            "AT-l0EYJL-UjnI8RsO_ebkRh-XpoTVBSCKGOfR0Q_JqW7O-cGUxxgrgibm8CDFE1eHccolNFWxH-wwAt", // Thay thế bằng Client ID từ PayPal Developer
        secretKey:
            "EK0JvKMHz8mRxTgu6TT4XQmZKgpcGt45kTRzS97TxMeVjgn0m1qpZ9bz7SuIvxIlaNGK7wUpvOYRLLjz", // Thay thế bằng Secret Key từ PayPal Developer
        transactions: [
          {
            "amount": {
              "total": totalAmountUSD.toStringAsFixed(2),
              "currency": "USD",
              "details": {
                "subtotal": totalAmountUSD.toStringAsFixed(2),
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": "Thanh toán giỏ hàng",
            "item_list": {
              "items": productQuantities.entries.map((entry) {
                final product = entry.key;
                final quantity = entry.value;
                return {
                  "name": product.name,
                  "quantity": quantity,
                  "price": (double.parse(product.priceSale) / 24000)
                      .toStringAsFixed(2), // Chuyển sang USD
                  "currency": "USD"
                };
              }).toList(),
            }
          }
        ],
        note: "Liên hệ với chúng tôi nếu có thắc mắc về đơn hàng.",
        onSuccess: (Map params) async {
          log("onSuccess: $params");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thanh toán thành công')),
          );
          setState(() {
            productQuantities.clear(); // Xóa giỏ hàng sau khi thanh toán
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: productQuantities.isEmpty
          ? const Center(child: Text('Giỏ hàng của bạn đang trống'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: productQuantities.length,
                    itemBuilder: (context, index) {
                      final product =
                          productQuantities.keys.toList()[index]; // Sản phẩm
                      final quantity =
                          productQuantities[product]!; // Số lượng sản phẩm
                      return ListTile(
                        leading: Image.network(
                          product.productImg,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${product.priceSale}đ / sản phẩm'),
                            Text(
                                'Tổng: ${calculateProductTotal(product).toStringAsFixed(0)}đ'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => decreaseQuantity(product),
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => increaseQuantity(product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeProduct(product),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     // const Text(
                      //     //   'Tổng tiền (VNĐ):',
                      //     //   style: TextStyle(
                      //     //       fontSize: 18, fontWeight: FontWeight.bold),
                      //     // ),
                      //     Text(
                      //       '${calculateTotal().toStringAsFixed(0)}đ',
                      //       style: const TextStyle(
                      //           fontSize: 18, fontWeight: FontWeight.bold),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng tiền (USD):',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${calculateTotalInUSD().toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _startPayPalPayment,
                  child: const Text('Thanh toán'),
                ),
              ],
            ),
    );
  }
}
