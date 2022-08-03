import 'package:aftersad_store/models/product_model.dart';

class OrderItemModel {
  OrderItemModel({required this.product, required this.qty});

  final ProductModel product;
  int qty;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      product: ProductModel.fromJson(json['product']),
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['product'] = product.toJson();
    _data['qty'] = qty;
    return _data;
  }
}
