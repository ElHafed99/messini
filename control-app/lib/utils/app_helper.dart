import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:messini_store/models/category_model.dart';
import 'package:messini_store/models/driver_model.dart';
import 'package:messini_store/models/order_model.dart';
import 'package:messini_store/models/product_model.dart';
import 'package:messini_store/models/slider_model.dart';
import 'package:messini_store/models/user_model.dart';
import 'package:messini_store/utils/app_const.dart';

class AppData {
  static const String URL = AppConst.url;

  Future<Map<String, dynamic>> firstRun() async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode(
          {"action": "firstRun"},
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);
    return res;
  }

  Future<Map<String, dynamic>> addProduct(
      {required ProductModel product}) async {
    Map<String, dynamic> body = product.toJson();
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({
          ...{"action": "addProduct"},
          ...body
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> addCategory(
      {required CategoryModel category}) async {
    Map<String, dynamic> body = category.toJson();
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({
          ...{"action": "addCategory"},
          ...body
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> addSlider({required SliderModel slider}) async {
    Map<String, dynamic> body = slider.toJson();
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({
          ...{"action": "addSlider"},
          ...body
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> addDriver({required DriverModel driver}) async {
    Map<String, dynamic> body = driver.toJson();
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({
          ...{"action": "addDriver"},
          ...body
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> editProduct(
      {required ProductModel product}) async {
    Map<String, dynamic> body = product.toJson();
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({
          ...{"action": "editProduct"},
          ...body
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> editCategory(
      {required CategoryModel category}) async {
    Map<String, dynamic> body = category.toJson();
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({
          ...{"action": "editCategory"},
          ...body
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> editSlider({required SliderModel slider}) async {
    Map<String, dynamic> body = slider.toJson();
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({
          ...{"action": "editSlider"},
          ...body
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<List<CategoryModel>> getAllCategories() async {
    List<CategoryModel> categories = [];
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getAllCategories"}),
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

  Future<List<Map<String, dynamic>>> getNotifications() async {
    List<Map<String, dynamic>> notifications = [];
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getNotifications"}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      Map resDecode = jsonDecode(response.body);

      List res = resDecode['data'];

      for (var element in res) {
        notifications.add(element);
      }
      return notifications;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<SliderModel>> getAllSliders() async {
    List<SliderModel> sliders = [];
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getAllSliders"}),
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

  Future<DriverModel> getDriverById({required String driverId}) async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getDriverById", "driverId": driverId}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      Map resDecode = jsonDecode(response.body);

      Map<String, dynamic> res = resDecode['data'];

      return DriverModel.fromJson(res);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    List<ProductModel> products = [];
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getAllProducts"}),
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

  Future<Map<String, dynamic>> deleteProduct(
      {required String productId}) async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "deleteProduct", "productId": productId}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> deleteUser({required String userUid}) async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "deleteUser", "userUid": userUid}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> deleteCategory(
      {required String categoryId}) async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body:
            jsonEncode({"action": "deleteCategory", "categoryId": categoryId}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> deleteSlider({required String sliderId}) async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "deleteSlider", "sliderId": sliderId}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> deleteDriver({required String driverId}) async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "deleteDriver", "driverId": driverId}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> deleteOrder({required String orderId}) async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "deleteOrder", "orderId": orderId}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<List<OrderModel>> getOrders() async {
    List<OrderModel> orders = [];

    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getOrders"}),
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

  Future<List<UserModel>> getUsers() async {
    List<UserModel> users = [];

    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getUsers"}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      Map resDecode = jsonDecode(response.body);

      List res = resDecode['data'];

      for (var element in res) {
        users.add(UserModel.fromJson(element));
      }
      return users;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<DriverModel>> getDrivers() async {
    List<DriverModel> drivers = [];

    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getDrivers"}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      Map resDecode = jsonDecode(response.body);

      List res = resDecode['data'];

      for (var element in res) {
        drivers.add(DriverModel.fromJson(element));
      }
      return drivers;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<http.Response> sendNotificationToUser({
    required String toUser,
    required String title,
    required String body,
  }) {
    return http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization":
            "key=	AAAAwYx_Wu4:APA91bHPRsw93IBucNjCmP1J0w7KD9f2YAk1SqCW0qqwwRUsgtg9Zr37u0SFRgncgN_Ox68C69__EuD5oK_MPZJ0WCzWi-y5CtuyHZYPoNLQ7Ssa93EKr641u-kNQ5FX36j6bKmglSR_"
      },
      body: jsonEncode(<String, dynamic>{
        "to": "/topics/$toUser",
        "notification": {"title": title, "body": body},
      }),
    );
  }

  Future<http.Response> sendNotification({
    required String toUser,
    required String title,
    required String body,
  }) {
    return http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization":
            "key=	AAAAwYx_Wu4:APA91bHPRsw93IBucNjCmP1J0w7KD9f2YAk1SqCW0qqwwRUsgtg9Zr37u0SFRgncgN_Ox68C69__EuD5oK_MPZJ0WCzWi-y5CtuyHZYPoNLQ7Ssa93EKr641u-kNQ5FX36j6bKmglSR_"
      },
      body: jsonEncode(<String, dynamic>{
        "condition": toUser == "all"
            ? "'user' in topics || 'driver' in topics"
            : "'$toUser' in topics",
        "notification": {"title": title, "body": body},
      }),
    );
  }

  Future<Map<String, dynamic>> addNotification(
      {required String title,
      required String description,
      required String toUser}) async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode(
          {
            "action": "addNotification",
            "title": title,
            "description": description,
            "toUser": toUser
          },
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }

  Future<Map<String, dynamic>> attachDriverToOrder(
      {required String orderId, required String driverId}) async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({
          "action": "attachDriverToOrder",
          "orderId": orderId,
          "driverId": driverId,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }
}
