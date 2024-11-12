class HistoryPrice {
  int dataId;
  String productName;
  String storeName;
  double price;
  double pricePerUnit;
  String unit;
  DateTime dateOfPrice;
  DateTime createdTime;

  HistoryPrice(this.dataId, this.productName, this.storeName, this.price,
      this.pricePerUnit, this.unit, this.dateOfPrice, this.createdTime);

  // Factory constructor for a single Product instance
  factory HistoryPrice.fromJson(Map<String, dynamic> json) {
    return HistoryPrice(
        json['dataId'],
        json['productName'],
        json['storeName'],
        json['price'],
        json['pricePerUnit'],
        json['unit'],
        DateTime.fromMillisecondsSinceEpoch(json['dateOfPrice'] * 1000),
        DateTime.fromMillisecondsSinceEpoch(json['createdTime']));
  }

  // Factory method for a list of Product instances
  static List<HistoryPrice> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => HistoryPrice.fromJson(json)).toList();
  }
}
