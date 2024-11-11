import 'package:ecogreen_city/screens/utilities/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailUtilities extends StatefulWidget {
  @override
  _DetailUtilitiesState createState() => _DetailUtilitiesState();
}

class _DetailUtilitiesState extends State<DetailUtilities> {
  List<Product> allProducts = []; // Full list of products
  List<Product> products = []; // Filtered list of products shown in UI
  Set<int> cartItems = {}; // Set to track added items by their index
  bool isLoading = true;
  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'https://nextstore-be.onrender.com/api/v1/televisions/showProduct'));

    if (response.statusCode == 200) {
      setState(() {
        allProducts = (json.decode(response.body)['data'] as List)
            .map((data) => Product.fromJson(data))
            .toList();
        products = allProducts; // Initialize products with the full list
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void updateSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, reset products to the full list
        products = allProducts;
      } else {
        // Otherwise, filter based on the search query
        products = allProducts
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void toggleCartItem(int index) {
    setState(() {
      if (cartItems.contains(index)) {
        // If already added to cart, remove it
        cartItems.remove(index);
        cartCount--;
      } else {
        // If not in cart, add it
        cartItems.add(index);
        cartCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5), // Semi-transparent background
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm trong cửa hàng...',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
            style: TextStyle(color: Colors.white),
            onChanged: updateSearch, // Call updateSearch on each text change
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.green),
                onPressed: () {
                  // Cart functionality
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$cartCount', // Dynamic cart count
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // More options functionality
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return buildProductCard(product, index);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildProductCard(Product product, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.productImg,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Discount Badge
              if (product.discount.isNotEmpty)
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    color: Colors.red,
                    child: Text(
                      product.discount,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                if (product.priceOld.isNotEmpty)
                  Text(
                    '${product.priceOld}đ',
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12,
                    ),
                  ),
                Text(
                  '${product.priceSale}đ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  '1 Cái',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          // Add to Cart Button
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: cartItems.contains(index) ? Colors.green : Colors.grey,
              ),
              onPressed: () {
                toggleCartItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
