class Product {
  int productId;
  String productName;
  String productCategory;
  String productImage;
  double? currentPrice;
  DateTime createdTime;
  DateTime updateTime;

  Product(this.productId, this.productName, this.productCategory,
      this.productImage, this.createdTime, this.updateTime, this.currentPrice);

  // Factory constructor for a single Product instance
  factory Product.fromJsonDTO(Map<String, dynamic> json) {
    return Product(
      json['productId'],
      json['productName'],
      json['productCategory'],
      json['productImage'],
      DateTime.parse(json['productCreatedTime']),
      DateTime.parse(json['productUpdatedTime']),
      null,
    );
  }

  // Factory method for a list of Product instances
  static List<Product> fromJsonDTOList(List<dynamic> jsonList) {
    return jsonList.map((json) => Product.fromJsonDTO(json)).toList();
  }
}
