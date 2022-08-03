import 'dart:convert';
import 'dart:js' as js;

import 'package:bs_flutter/bs_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:messini_store/models/driver_model.dart';
import 'package:messini_store/models/order_item_model.dart';
import 'package:messini_store/models/order_model.dart';
import 'package:messini_store/models/order_status_model.dart';
import 'package:messini_store/utils/app_const.dart';
import 'package:messini_store/utils/app_helper.dart';
import 'package:messini_store/utils/app_themes.dart';
import 'package:messini_store/utils/app_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrderListPage extends StatefulWidget {
  final String? userUid;
  const OrderListPage({Key? key, this.userUid}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  bool isLoading = true;
  late List<OrderModel> orders;
  late List<OrderModel> filterOrders;

  getAllOrder() async {
    setState(() {
      isLoading = true;
      isFilter = false;
      orderStatus = "All";
      timeOrder = "new";
    });
    orders = [];
    await AppData().getOrders().then((value) {
      orders = widget.userUid == null
          ? value
          : value
              .where((element) => element.userUid == widget.userUid)
              .toList();
      orders.sort(
        (a, b) {
          return b.createdAt!.compareTo(a.createdAt!);
        },
      );
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isFilter = false;

  filterResult({required String status, required String timeOrder}) {
    setState(() {
      filterOrders = [];
    });
    if (status == "canceled") {
      setState(() {
        filterOrders
            .addAll(orders.where((element) => element.statusId == -1).toList());
        isFilter = true;
      });
    } else if (status == "pending") {
      setState(() {
        filterOrders
            .addAll(orders.where((element) => element.statusId == 0).toList());
        isFilter = true;
      });
    } else if (status == "working") {
      setState(() {
        filterOrders
            .addAll(orders.where((element) => element.statusId == 1).toList());
        isFilter = true;
      });
    } else if (status == "delivered") {
      setState(() {
        filterOrders
            .addAll(orders.where((element) => element.statusId == 2).toList());
        isFilter = true;
      });
    } else {
      setState(() {
        isFilter = false;
      });
    }

    if (timeOrder == "new") {
      setState(() {
        orders.sort(
          (a, b) {
            return b.createdAt!.compareTo(a.createdAt!);
          },
        );
        filterOrders.sort(
          (a, b) {
            return b.createdAt!.compareTo(a.createdAt!);
          },
        );
      });
    } else {
      setState(() {
        orders.sort(
          (a, b) {
            return a.createdAt!.compareTo(b.createdAt!);
          },
        );
        filterOrders.sort(
          (a, b) {
            return a.createdAt!.compareTo(b.createdAt!);
          },
        );
      });
    }
  }

  String orderStatus = "All";
  String timeOrder = "new";

  bool isDriverLoading = true;
  List<DriverModel> drivers = [];

  getAllDriver() async {
    setState(() {
      isDriverLoading = true;
      drivers = [];
    });

    await AppData().getDrivers().then((value) {
      drivers = value.where((element) => element.available == 1).toList();
      setState(() {
        isDriverLoading = false;
      });
    });
  }

  @override
  void initState() {
    getAllOrder();
    getAllDriver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: SizedBox(
                width: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: const LinearProgressIndicator(
                    minHeight: 10,
                  ),
                ),
              ),
            )
          : ListView(
              controller: ScrollController(),
              padding: const Margin.all(10.0),
              shrinkWrap: true,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  alignment: WrapAlignment.end,
                  children: [
                    FilterChip(
                      label: Text("all".tr()),
                      onSelected: (bool value) {
                        setState(() {
                          orderStatus = "All";
                          filterResult(status: "All", timeOrder: timeOrder);
                        });
                      },
                      selected: orderStatus == "All",
                      selectedColor: AppThemes.primaryColor,
                      checkmarkColor: AppThemes.lightGreyColor,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: orderStatus == "All"
                                  ? AppThemes.lightGreyColor
                                  : AppThemes.darkColor),
                    ),
                    ...List.generate(OrderStatusModel.orderStatus.length, (i) {
                      OrderStatusModel oStatus =
                          OrderStatusModel.orderStatus[i];
                      return FilterChip(
                        label: Text(oStatus.title.tr()),
                        onSelected: (bool value) {
                          setState(() {
                            orderStatus = oStatus.title;
                            filterResult(
                                status: oStatus.title, timeOrder: timeOrder);
                          });
                        },
                        selected: orderStatus == oStatus.title,
                        selectedColor: AppThemes.primaryColor,
                        checkmarkColor: AppThemes.lightGreyColor,
                        avatar: orderStatus == oStatus.title
                            ? null
                            : Icon(
                                oStatus.icon,
                                color: oStatus.color,
                              ),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                                color: orderStatus == oStatus.title
                                    ? AppThemes.lightGreyColor
                                    : AppThemes.darkColor),
                      );
                    }),
                  ],
                ),
                const Divider(),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  alignment: WrapAlignment.end,
                  children: [
                    FilterChip(
                      label: Text("newFirst".tr()),
                      onSelected: (bool value) {
                        setState(() {
                          timeOrder = "new";
                          filterResult(status: orderStatus, timeOrder: "new");
                        });
                      },
                      selected: timeOrder == "new",
                      selectedColor: AppThemes.primaryColor,
                      checkmarkColor: AppThemes.lightGreyColor,
                      avatar: timeOrder == "new"
                          ? null
                          : const Icon(
                              Ionicons.chevron_down,
                            ),
                      labelStyle: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: timeOrder == "new"
                                  ? AppThemes.lightGreyColor
                                  : AppThemes.darkColor),
                    ),
                    FilterChip(
                      label: Text("oldFirst".tr()),
                      onSelected: (bool value) {
                        setState(() {
                          timeOrder = "old";
                          filterResult(status: orderStatus, timeOrder: "old");
                        });
                      },
                      selected: timeOrder == "old",
                      selectedColor: AppThemes.primaryColor,
                      checkmarkColor: AppThemes.lightGreyColor,
                      avatar: timeOrder == "old"
                          ? null
                          : const Icon(
                              Ionicons.chevron_up,
                            ),
                      labelStyle: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: timeOrder == "old"
                                  ? AppThemes.lightGreyColor
                                  : AppThemes.darkColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                BsRow(
                    //alignment: Alignment.center,
                    children: List.generate(
                        isFilter ? filterOrders.length : orders.length,
                        (index) {
                  OrderModel order =
                      isFilter ? filterOrders[index] : orders[index];

                  OrderStatusModel orderStatus = OrderStatusModel.orderStatus
                      .firstWhere((element) => element.id == order.statusId);
                  return BsCol(
                    padding: const Margin.all(5.0),
                    sizes: const ColScreen(
                      xs: Col.col_12,
                      sm: Col.col_12,
                      md: Col.col_6,
                      lg: Col.col_6,
                      xl: Col.col_6,
                      xxl: Col.col_4,
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: EdgeRadius.all(10)),
                      tileColor: Colors.white,
                      onTap: () {
                        infoDialog(order: order);
                      },
                      title: Text("${'order'.tr()} #${order.id}"),
                      subtitle: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          Chip(
                            avatar: Icon(
                              orderStatus.icon,
                              color: Colors.white,
                            ),
                            label: Text(orderStatus.title.tr(),
                                style: const TextStyle(color: Colors.white)),
                            backgroundColor: orderStatus.color,
                          ),
                        ],
                      ),
                      trailing: Text(
                        timeago.format(
                            DateFormat("yyyy-MM-dd hh:mm:ss")
                                .parse(order.createdAt!),
                            locale: translator.activeLanguageCode + '_short'),
                      ),
                    ),
                  );
                }))
              ],
            ),
    );
  }

  infoDialog({required OrderModel order}) {
    double totalPrice = 0;
    showDialog(
        context: context,
        builder: (context) {
          int stId = order.statusId;
          int driverId = order.driverId!;
          List orderItemList =
              json.decode(HtmlUnescape().convert(order.orderItems));
          OrderStatusModel orderStatus = OrderStatusModel.orderStatus
              .firstWhere((element) => element.id == stId);

          for (var element in orderItemList) {
            totalPrice += OrderItemModel.fromJson(element).product.price *
                OrderItemModel.fromJson(element).qty;
          }
          return StatefulBuilder(builder: (context, ssInfo) {
            return AlertDialog(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
              contentPadding: const Margin.bottom(10),
              titlePadding: Margin.zero,
              title: Container(
                padding: const Margin.vertical(20),
                color: context.color.primary,
                child: Column(
                  children: [
                    Text(
                      "${'order'.tr()} #${order.id}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Chip(
                      avatar: const Icon(
                        Ionicons.time_outline,
                        color: Colors.white,
                      ),
                      label: Text(
                          timeago.format(
                              DateFormat("yyyy-MM-dd hh:mm:ss")
                                  .parse(order.createdAt!),
                              locale: translator.activeLanguageCode),
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.blue,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Chip(
                      avatar: Icon(
                        orderStatus.icon,
                        color: Colors.white,
                      ),
                      label: Text(orderStatus.title.tr(),
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: orderStatus.color,
                    ),
                  ],
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * .7 > 500
                    ? 500
                    : MediaQuery.of(context).size.width,
                child: ListView(
                  controller: ScrollController(),
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      minVerticalPadding: 0,
                      title: Text("userPhone".tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(order.userPhone),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              js.context.callMethod(
                                  'open', ['tel:${order.userPhone}']);
                            },
                            icon: const Icon(Ionicons.call),
                            tooltip: "call".tr(),
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                      ClipboardData(text: order.userPhone))
                                  .then((_) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                  "phoneCopied".tr(),
                                  style: const TextStyle(color: Colors.white),
                                )));
                              });
                            },
                            icon: const Icon(Ionicons.copy),
                            tooltip: "copy".tr(),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      minVerticalPadding: 0,
                      title: Text(
                        "userLocation".tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(order.userLocation),
                      trailing: IconButton(
                        onPressed: () {
                          js.context.callMethod('open', [
                            'https://www.google.com/maps/search/?api=1&query=${order.userLatLng}'
                          ]);
                        },
                        icon: const Icon(Ionicons.map),
                        tooltip: "openMap".tr(),
                      ),
                    ),
                    stId > 0
                        ? ListTile(
                            onTap: () async {
                              AppWidgets().MyDialog(
                                  context: context,
                                  title: "loading".tr(),
                                  background: Colors.blue,
                                  asset: const CircularProgressIndicator(
                                      color: Colors.white));
                              await AppData()
                                  .getDriverById(driverId: "$driverId")
                                  .then((value) {
                                Get.back();
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: EdgeRadius.all(10)),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Headline6(
                                              value.name,
                                              textAlign: TextAlign.center,
                                            ),
                                            SelectableText(
                                              value.phone,
                                              textAlign: TextAlign.center,
                                            ),
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              alignment: WrapAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon:
                                                      const Icon(Ionicons.call),
                                                  tooltip: "call".tr(),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                            ClipboardData(
                                                                text: value
                                                                    .phone))
                                                        .then((_) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                        "phoneCopied".tr(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )));
                                                    });
                                                  },
                                                  icon:
                                                      const Icon(Ionicons.copy),
                                                  tooltip: "copy".tr(),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          String title = "";
                                                          String description =
                                                              "";
                                                          return StatefulBuilder(
                                                              builder: (context,
                                                                  ssNotify) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "sendNotification"
                                                                      .tr()),
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      EdgeRadius
                                                                          .all(
                                                                              16)),
                                                              content: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  TextField(
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      labelText:
                                                                          "title"
                                                                              .tr(),
                                                                      filled:
                                                                          true,
                                                                    ),
                                                                    onChanged:
                                                                        (v) {
                                                                      ssNotify(
                                                                          () {
                                                                        title =
                                                                            v;
                                                                      });
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  TextField(
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          "description"
                                                                              .tr(),
                                                                      filled:
                                                                          true,
                                                                    ),
                                                                    maxLines: 5,
                                                                    minLines: 4,
                                                                    onChanged:
                                                                        (v) {
                                                                      ssNotify(
                                                                          () {
                                                                        description =
                                                                            v;
                                                                      });
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Get.back();
                                                                            AppData().sendNotificationToUser(
                                                                              toUser: "${value.id}",
                                                                              title: title,
                                                                              body: description,
                                                                            );
                                                                          },
                                                                          child:
                                                                              Text("send".tr())),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Get.back();
                                                                        },
                                                                        child: Text(
                                                                            "cancel".tr()),
                                                                        style: Get
                                                                            .theme
                                                                            .elevatedButtonTheme
                                                                            .style!
                                                                            .copyWith(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                        });
                                                  },
                                                  icon: const Icon(
                                                      Ionicons.notifications),
                                                  tooltip:
                                                      "sendNotification".tr(),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              });
                            },
                            minVerticalPadding: 0,
                            title: Text(
                              "orderDriver".tr(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("ViewDriverInfo".tr()),
                            trailing: Icon(translator.activeLanguageCode == 'ar'
                                ? Ionicons.chevron_back
                                : Ionicons.chevron_forward))
                        : Container(),
                    ListTile(
                      title: Text(
                        "orderItems".tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: GridView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      (MediaQuery.of(context).size.width * .7 >
                                                  400
                                              ? 400
                                              : MediaQuery.of(context)
                                                  .size
                                                  .width) ~/
                                          50),
                          itemCount: orderItemList.length,
                          itemBuilder: (context, index) {
                            OrderItemModel orderItem =
                                OrderItemModel.fromJson(orderItemList[index]);
                            return Tooltip(
                              message: orderItem.product.title,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Card(
                                    color: context.color.scaffold,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: EdgeRadius.all(10)),
                                    clipBehavior: Clip.antiAlias,
                                    child: CachedNetworkImage(
                                      imageUrl: orderItem.product.image,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Colors.grey,
                                      ),
                                      fit: BoxFit.cover,
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
                              ),
                            );
                          }),
                    ),
                    const Divider(),
                    ListTile(
                      dense: true,
                      title: Subtitle1("${'subtotal'.tr()}: "),
                      trailing: Subtitle1(
                        "$totalPrice ${AppConst.appCurrency}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: Subtitle1("${'deliveryFee'.tr()}: "),
                      trailing: const Subtitle1(
                        "${AppConst.fee} ${AppConst.appCurrency}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: Subtitle1("${'total'.tr()}: "),
                      trailing: Subtitle1(
                        "${totalPrice + AppConst.fee} ${AppConst.appCurrency}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.color.primary),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text("action".tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      title: Text("attachDriver".tr()),
                      minLeadingWidth: 0,
                      leading: const Icon(Ionicons.bicycle),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, ssDriver) {
                                return AlertDialog(
                                    title: Text("attachDriver".tr()),
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: EdgeRadius.all(16)),
                                    content: isDriverLoading
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Headline6("loadingDrivers".tr()),
                                              const SizedBox(height: 32),
                                              const LinearProgressIndicator()
                                            ],
                                          )
                                        : SizedBox(
                                            width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .7 >
                                                    500
                                                ? 500
                                                : MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ...List.generate(
                                                    drivers.length,
                                                    (i) => ListTile(
                                                          minLeadingWidth: 0,
                                                          onTap: () async {
                                                            await AppData()
                                                                .attachDriverToOrder(
                                                                    orderId:
                                                                        "${order.id}",
                                                                    driverId:
                                                                        "${drivers[i].id}")
                                                                .then((value) {
                                                              if (value[
                                                                      'type'] ==
                                                                  "success") {
                                                                AppData()
                                                                    .sendNotificationToUser(
                                                                  toUser:
                                                                      "${drivers[i].id}",
                                                                  // TODO Later
                                                                  title:
                                                                      "New Order",
                                                                  body:
                                                                      "You have new order to deliver it",
                                                                );
                                                                AppData()
                                                                    .sendNotificationToUser(
                                                                  toUser: order
                                                                      .userUid,
                                                                  title:
                                                                      "Order updated",
                                                                  body:
                                                                      "You Order Status is on Working now",
                                                                );
                                                                Get.back();
                                                                ssInfo(() {
                                                                  stId = 1;
                                                                  driverId =
                                                                      drivers[i]
                                                                          .id!;
                                                                  orderStatus = OrderStatusModel
                                                                      .orderStatus
                                                                      .firstWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          stId);
                                                                });
                                                                getAllOrder();
                                                              } else {
                                                                AppWidgets().MyDialog(
                                                                    context: context,
                                                                    title: "error".tr(),
                                                                    background: Colors.red,
                                                                    asset: const Icon(
                                                                      Ionicons
                                                                          .close_circle,
                                                                      size: 80,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    confirm: TextButton(
                                                                        onPressed: () {
                                                                          Get.back();
                                                                        },
                                                                        child: Text("ok".tr())));
                                                              }
                                                            });
                                                          },
                                                          leading: const Icon(
                                                              Ionicons.bicycle),
                                                          title: Text(
                                                              drivers[i].name),
                                                          subtitle: Text(
                                                              drivers[i].phone),
                                                        ))
                                              ],
                                            ),
                                          ));
                              });
                            });
                      },
                      enabled: stId == 0,
                    ),
                    ListTile(
                      title: Text("sendNotificationToUser".tr()),
                      minLeadingWidth: 0,
                      leading: const Icon(Ionicons.notifications),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              String title = "";
                              String description = "";
                              return StatefulBuilder(
                                  builder: (context, ssNotify) {
                                return AlertDialog(
                                  title: Text("sendNotification".tr()),
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: EdgeRadius.all(16)),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: "title".tr(),
                                          filled: true,
                                        ),
                                        onChanged: (v) {
                                          ssNotify(() {
                                            title = v;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "description".tr(),
                                          filled: true,
                                        ),
                                        maxLines: 5,
                                        minLines: 4,
                                        onChanged: (v) {
                                          ssNotify(() {
                                            description = v;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Get.back();
                                                AppData()
                                                    .sendNotificationToUser(
                                                  toUser: order.userUid,
                                                  title: title,
                                                  body: description,
                                                );
                                              },
                                              child: Text("send".tr())),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text("cancel".tr()),
                                            style: Get.theme.elevatedButtonTheme
                                                .style!
                                                .copyWith(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red)),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                            });
                      },
                    ),
                    ListTile(
                      title: Text("deleteOrder".tr()),
                      minLeadingWidth: 0,
                      leading: const Icon(
                        Ionicons.close_circle,
                        color: Colors.red,
                      ),
                      onTap: () {
                        AppWidgets().MyDialog(
                          context: context,
                          background: Colors.blue,
                          title: "delete".tr(),
                          subtitle: "deleteOrderDescription".tr(),
                          asset: const Icon(
                            Ionicons.information_circle,
                            size: 80,
                            color: Colors.white,
                          ),
                          confirm: ElevatedButton(
                            onPressed: () async {
                              Get.back();
                              AppWidgets().MyDialog(
                                  context: context,
                                  title: "loading".tr(),
                                  background: Colors.blue,
                                  asset: const CircularProgressIndicator(
                                      color: Colors.white));
                              await AppData()
                                  .deleteOrder(orderId: "${order.id}")
                                  .then((value) async {
                                Get.back();
                                if (value['type'] == "success") {
                                  Get.back();
                                  setState(() {
                                    orders.removeWhere(
                                        (element) => element.id == order.id);
                                  });
                                } else {
                                  AppWidgets().MyDialog(
                                      context: context,
                                      title: "error".tr(),
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
                                          child: Text("ok".tr())));
                                }
                              });
                            },
                            child: Text("yes".tr()),
                            style: Get.theme.elevatedButtonTheme.style!
                                .copyWith(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                          ),
                          cancel: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("no".tr()),
                            style: Get.theme.elevatedButtonTheme.style!
                                .copyWith(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blueGrey)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
