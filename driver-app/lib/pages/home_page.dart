import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:helpers/helpers.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:store_driver/models/order_model.dart';
import 'package:store_driver/models/order_status_model.dart';
import 'package:store_driver/pages/map_page.dart';
import 'package:store_driver/utils/app_helper.dart';
import 'package:store_driver/utils/app_themes.dart';
import 'package:store_driver/utils/app_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<OrderModel>> futureUserOrderList;

  @override
  void initState() {
    futureUserOrderList = AppData().getDriverOrders(
        driverId: GetStorage().read('driverData')['id'].toString());
    super.initState();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
              futureUserOrderList = AppData().getDriverOrders(
                  driverId: GetStorage().read('driverData')['id'].toString());
            });
            _refreshController.refreshCompleted();
          },
          child: FutureBuilder<List<OrderModel>>(
            future: futureUserOrderList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<OrderModel> orders = snapshot.data!;
                return snapshot.data!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        padding: const Margin.all(10),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          OrderModel order = orders[index];

                          OrderStatusModel currentOrderStatus =
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
                                  onTap: () {
                                    if (order.statusId.toString() == "1") {
                                      Get.to(() => MapPage(
                                            order: order,
                                          ));
                                    }
                                  },
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
                                          currentOrderStatus.icon,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                            currentOrderStatus.title.tr(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        backgroundColor:
                                            currentOrderStatus.color,
                                      ),
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
                print(snapshot.error);
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
                        ),
                        Subtitle1(
                          "${snapshot.error}",
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
}
