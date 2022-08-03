import 'dart:convert';

import 'package:aftersad_store/models/order_item_model.dart';
import 'package:aftersad_store/models/order_model.dart';
import 'package:aftersad_store/models/order_status_model.dart';
import 'package:aftersad_store/utils/app_const.dart';
import 'package:aftersad_store/utils/app_helper.dart';
import 'package:aftersad_store/utils/app_themes.dart';
import 'package:aftersad_store/utils/app_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late Future<List<OrderModel>> futureUserOrderList;

  double totalPrice = 0;

  getOrderTotalPrice(List orderItemList) {
    setState(() {
      totalPrice = 0;
    });
    for (var element in orderItemList) {
      setState(() {
        totalPrice += OrderItemModel.fromJson(element).product.price *
            OrderItemModel.fromJson(element).qty;
      });
    }
  }

  @override
  void initState() {
    futureUserOrderList = AppData()
        .getUserOrders(userUid: FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Headline6("orders".tr(),
              style: TextStyle(
                  color: AppThemes.lightGreyColor,
                  fontWeight: FontWeight.bold)),
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: () {
            setState(() {
              futureUserOrderList = AppData().getUserOrders(
                  userUid: FirebaseAuth.instance.currentUser!.uid);
            });
            _refreshController.refreshCompleted();
          },
          child: FutureBuilder<List<OrderModel>>(
            future: futureUserOrderList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        padding: const Margin.all(10),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          OrderModel order = snapshot.data![index];
                          List orderItemList = json
                              .decode(HtmlUnescape().convert(order.orderItems));
                          OrderStatusModel orderStatus =
                              OrderStatusModel.orderStatus.firstWhere(
                                  (element) => element.id == order.statusId);
                          return Card(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: EdgeRadius.all(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding:
                                      const Margin.symmetric(horizontal: 10),
                                  title: Text("${'order'.tr()} #${order.id}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                    timeago.format(
                                        DateFormat("yyyy-MM-dd hh:mm:ss")
                                            .parse(order.createdAt!),
                                        locale: translator.activeLanguageCode),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Chip(
                                        avatar: Icon(
                                          orderStatus.icon,
                                          color: Colors.white,
                                        ),
                                        label: Text(orderStatus.title.tr(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        backgroundColor: orderStatus.color,
                                      ),
                                      PopupMenuButton(
                                          offset: const Offset(0, 40),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: EdgeRadius.all(10)),
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem<int>(
                                                value: 1,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Ionicons.list,
                                                    ),
                                                    SizedBox(width: 16),
                                                    Expanded(
                                                        child: Text(
                                                            "viewOrderDetails"
                                                                .tr())),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<int>(
                                                enabled: (order.statusId == 0),
                                                value: 2,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Ionicons.close_circle,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(width: 16),
                                                    Expanded(
                                                        child: Text(
                                                      "cancelOrder".tr(),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ];
                                          },
                                          onSelected: (value) async {
                                            if (value == 1) {
                                              getOrderTotalPrice(orderItemList);
                                              showModalBottomSheet<void>(
                                                context: context,
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        EdgeRadius.top(16)),
                                                builder:
                                                    (BuildContext context) {
                                                  return orderItemDetails(
                                                      order,
                                                      orderStatus,
                                                      orderItemList);
                                                },
                                              );
                                            } else if (value == 2) {
                                              AppWidgets().MyDialog(
                                                  context: context,
                                                  title: "loading".tr(),
                                                  background: Colors.blue,
                                                  asset:
                                                      const CircularProgressIndicator(
                                                          color: Colors.white));
                                              await AppData()
                                                  .cancelOrder(
                                                      orderId: "${order.id}")
                                                  .then((value) {
                                                Get.back();
                                                if (value['type'] ==
                                                    "success") {
                                                  AppWidgets().MyDialog(
                                                      context: context,
                                                      title: "success".tr(),
                                                      background:
                                                          context.color.primary,
                                                      asset: const Icon(
                                                        Ionicons
                                                            .checkmark_circle,
                                                        size: 80,
                                                        color: Colors.white,
                                                      ),
                                                      confirm: TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                            setState(() {
                                                              futureUserOrderList =
                                                                  AppData().getUserOrders(
                                                                      userUid: FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid);
                                                            });
                                                          },
                                                          child:
                                                              Text("ok".tr())));
                                                } else {
                                                  AppWidgets().MyDialog(
                                                      context: context,
                                                      title: "sww".tr(),
                                                      background: Colors.red,
                                                      asset: const Icon(
                                                        Ionicons.close_circle,
                                                        size: 80,
                                                        color: Colors.white,
                                                      ),
                                                      confirm: TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child:
                                                              Text("ok".tr())));
                                                }
                                              });
                                            }
                                          })
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                    : AppWidgets().EmptyDataWidget(
                        title: "orderNoItem".tr(),
                        icon: Ionicons.bag_handle_outline);
              } else if (snapshot.hasError) {
                return Card(
                  elevation: 0.0,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Ionicons.planet_outline,
                          size: 50,
                        ),
                        Subtitle1(
                          "sww".tr(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const Margin.all(10),
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Shimmer(
                    child: const Card(
                      margin: EdgeInsets.all(4),
                      child: SizedBox(
                        height: 60,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }

  orderItemDetails(
      OrderModel order, OrderStatusModel orderStatus, List orderItemList) {
    return Padding(
      padding: const Margin.all(10.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 100,
        ),
        child: ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  Headline5(
                    "${totalPrice + AppConst.fee} ${AppConst.appCurrency}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    avatar: Icon(
                      orderStatus.icon,
                      color: Colors.white,
                    ),
                    label: Text(orderStatus.title.tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    backgroundColor: orderStatus.color,
                  ),
                  Text("orderPasscode".tr()),
                  Headline6(
                    order.passcode,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            ListTile(
              title: Text("phone".tr()),
              subtitle: Text(order.userPhone),
            ),
            ListTile(
              title: Text("address".tr()),
              subtitle: Text(order.userLocation),
            ),

            ListTile(
              title: Text("orderItems".tr()),
            ),
            //const Headline6("Order Items"),
            GridView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                padding: const Margin.symmetric(horizontal: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6),
                itemCount: orderItemList.length,
                itemBuilder: (context, index) {
                  OrderItemModel orderItem =
                      OrderItemModel.fromJson(orderItemList[index]);
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Tooltip(
                        message: orderItem.product.title,
                        child: Card(
                          color: context.color.scaffold,
                          shape: RoundedRectangleBorder(
                              borderRadius: EdgeRadius.all(10)),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl: orderItem.product.image,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Ionicons.image, size: 48),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.blueGrey,
                          child: BodyText1(
                            "${orderItem.qty}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
