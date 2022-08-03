import 'dart:convert';

import 'package:aftersad_store/models/category_model.dart';
import 'package:aftersad_store/models/order_model.dart';
import 'package:aftersad_store/models/product_model.dart';
import 'package:aftersad_store/models/slider_model.dart';
import 'package:aftersad_store/utils/app_const.dart';
import 'package:http/http.dart' as http;

class AppData {
  static const String URL = AppConst.url;

  checkUserExist({required String userPhone, required String userUid}) async {
    await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({
          "action": "checkUserExist",
          "userPhone": userPhone,
          "userUid": userUid
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
  }

  Future<List<SliderModel>> getSliders() async {
    List<SliderModel> sliders = [];
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getSliders"}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      Map resDecode = jsonDecode(response.body);

      List res = resDecode['data'];

      for (var element in res) {
        sliders.add(SliderModel.fromJson(element));
      }
      return sliders;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<ProductModel>> getLatestProducts() async {
    List<ProductModel> products = [];
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getLatestProducts"}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      Map resDecode = jsonDecode(response.body);

      List res = resDecode['data'];

      for (var element in res) {
        products.add(ProductModel.fromJson(element));
      }
      return products;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> categories = [];
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getCategories"}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      Map resDecode = jsonDecode(response.body);

      List res = resDecode['data'];

      for (var element in res) {
        categories.add(CategoryModel.fromJson(element));
      }
      return categories;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<ProductModel>> getProductByCategory(
      {required int categoryId}) async {
    List<ProductModel> products = [];
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode(
            {"action": "getProductByCategory", "categoryId": categoryId}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      Map resDecode = jsonDecode(response.body);

      List res = resDecode['data'];

      for (var element in res) {
        products.add(ProductModel.fromJson(element));
      }
      return products;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<OrderModel>> getUserOrders({required String userUid}) async {
    List<OrderModel> orders = [];

    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getUserOrders", "userUid": userUid}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      Map resDecode = jsonDecode(response.body);

      List res = resDecode['data'];

      for (var element in res) {
        orders.add(OrderModel.fromJson(element));
      }
      return orders;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Map<String, dynamic>> addOrder(
      {required OrderModel orderModel}) async {
    Map<String, dynamic> body = orderModel.toJson();
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({
          ...{"action": "addOrder"},
          ...body
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> cancelOrder({required String orderId}) async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "cancelOrder", "orderId": orderId}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }
}
