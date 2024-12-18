import 'package:ecogreen_city/screens/stores/card_screen.dart';
import 'package:ecogreen_city/screens/stores/cart_screen.dart';
import 'package:flutter/material.dart';

class DetailStoreScreen extends StatefulWidget {
  final Map<String, dynamic> store;
  const DetailStoreScreen({super.key, required this.store});

  @override
  State<DetailStoreScreen> createState() => _DetailStoreScreenState();
}

class _DetailStoreScreenState extends State<DetailStoreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  int cartCount = 0;
  Set<dynamic> cartItems = {};
  Map<dynamic, int> productQuantities = {};

  @override
  void initState() {
    super.initState();
    products = widget.store['products'] ?? [];
    filteredProducts = products;
  }

  void _filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product['name']?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    });
  }

  void _toggleCart(dynamic product) {
    setState(() {
      if (cartItems.contains(product)) {
        cartItems.remove(product);
        productQuantities.remove(product);
        cartCount--;
      } else {
        cartItems.add(product);
        productQuantities[product] = 1;
        cartCount++;
      }
    });
  }

  void _navigateToCartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cartItems: cartItems.toList(),
          productQuantities: productQuantities,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: _filterProducts,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm',
                  border: InputBorder.none,
                ),
              ),
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: _navigateToCartScreen,
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      widget.store['image'] ??
                          'https://via.placeholder.com/150',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.store['name'] ?? 'Không có tên',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.store['description'] ?? 'Không có mô tả',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.store['address'] ?? 'Không có địa chỉ',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Danh sách sản phẩm',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...filteredProducts.map((product) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
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
                              product['description'] ?? 'Không có mô tả',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Giá: ${product['price']}đ',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Còn lại: ${product['stock']} sản phẩm',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          cartItems.contains(product)
                              ? Icons.shopping_cart
                              : Icons.shopping_cart_outlined,
                          color: Colors.green,
                        ),
                        onPressed: () => _toggleCart(product),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
