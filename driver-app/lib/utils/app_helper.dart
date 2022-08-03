import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:store_driver/models/order_model.dart';
import 'package:store_driver/utils/app_const.dart';

class AppData {
  static const String URL = AppConst.url;

  Future getDriverByPhone({required String driverPhone}) async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode(
            {"action": "getDriverByPhone", "driverPhone": driverPhone}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
//    print(response.body);
    if (response.statusCode == 200) {
      var resDecode = jsonDecode(response.body);

      return resDecode;
    }
  }

  Future<List<OrderModel>> getDriverOrders({required String driverId}) async {
    List<OrderModel> orders = [];

    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({"action": "getDriverOrders", "driverId": driverId}),
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

  Future<Map<String, dynamic>> confirmOrder(
      {required String orderId, required String driverId}) async {
    final response = await http.post(Uri.parse('$URL/api.php'),
        body: jsonEncode({
          "action": "confirmOrder",
          "orderId": orderId,
          "driverId": driverId
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    print(response.body);
    Map<String, dynamic> res = jsonDecode(response.body);

    return res;
  }
}
