class Price {
  int priceId;
  String productName;
  String productCategory;
  String storeName;
  double price;
  String size;
  double pricePerUnit;
  String unit;
  DateTime startDate;
  DateTime endDate;
  DateTime updatedTime;

  Price(
      this.priceId,
      this.productName,
      this.productCategory,
      this.storeName,
      this.price,
      this.size,
      this.pricePerUnit,
      this.unit,
      this.startDate,
      this.endDate,
      this.updatedTime);

  // Factory constructor for a single Product instance
  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      json['priceId'],
      json['productName'],
      json['productCategory'],
      json['storeName'],
      json['price'],
      json['size'],
      json['pricePerUnit'],
      json['unit'],
      DateTime.parse(json['startDate']),
      DateTime.parse(json['endDate']),
      DateTime.parse(json['updatedTime']),
    );
  }
  // Factory method for a list of Product instances
  static List<Price> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Price.fromJson(json)).toList();
  }
}
