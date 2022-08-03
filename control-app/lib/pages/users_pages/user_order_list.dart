import 'package:messini_store/pages/order_pages/order_list_page.dart';
import 'package:messini_store/utils/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class UserOrderList extends StatefulWidget {
  final String userUid;
  const UserOrderList({Key? key, required this.userUid}) : super(key: key);

  @override
  _UserOrderListState createState() => _UserOrderListState();
}

class _UserOrderListState extends State<UserOrderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Headline6(
          "userOrders".tr(),
          style: const TextStyle(
              color: AppThemes.lightGreyColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: OrderListPage(
        userUid: widget.userUid,
      ),
    );
  }
}
