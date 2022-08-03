class ProductModel {
  ProductModel({
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.unit,
    required this.unitSize,
    this.id,
    required this.categoryId,
    required this.showToUser,
  });

  final String title;
  final String image;
  final String description;
  final double price;
  final String unit;
  final double unitSize;
  final int? id;
  final int categoryId;
  final int showToUser;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        title: json['title'],
        image: json['image'],
        description: json['description'],
        price: double.parse(json['price'].toString()),
        unit: json['unit'],
        unitSize: double.parse(json['unitSize'].toString()),
        id: int.parse(json['id'].toString()),
        categoryId: int.parse(json['categoryId'].toString()),
        showToUser: int.parse(json['showToUser'].toString()));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['image'] = image;
    _data['description'] = description;
    _data['price'] = price;
    _data['unit'] = unit;
    _data['unitSize'] = unitSize;
    _data['id'] = id;
    _data['categoryId'] = categoryId;
    _data['showToUser'] = showToUser;

    return _data;
  }
}
