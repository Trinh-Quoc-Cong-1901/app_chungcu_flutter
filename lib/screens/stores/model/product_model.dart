// Product Model
 class Product {
  final String id;
  final int pdId;
  final String name;
  final String size;
  final String resolution;
  final String priceOld;
  final String discount;
  final String priceSale;
  final String rating;
  final String ratingNumber;
  final String productImg;
  final String slug;

  Product({
    required this.id,
    required this.pdId,
    required this.name,
    required this.size,
    required this.resolution,
    required this.priceOld,
    required this.discount,
    required this.priceSale,
    required this.rating,
    required this.ratingNumber,
    required this.productImg,
    required this.slug,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      pdId: json['PD_id'],
      name: json['name'],
      size: json['size'],
      resolution: json['resolution'],
      priceOld: json['price_old'],
      discount: json['discount'],
      priceSale: json['price_sale'],
      rating: json['rating'],
      ratingNumber: json['rating_number'],
      productImg: json['product_img'],
      slug: json['slug'],
    );
  }
}