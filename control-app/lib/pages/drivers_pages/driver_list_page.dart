import 'dart:js' as js;

import 'package:bs_flutter/bs_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:messini_store/models/driver_model.dart';
import 'package:messini_store/pages/drivers_pages/add_driver_page.dart';
import 'package:messini_store/utils/app_helper.dart';
import 'package:messini_store/utils/app_themes.dart';
import 'package:messini_store/utils/app_widgets.dart';

class DriverListPage extends StatefulWidget {
  const DriverListPage({Key? key}) : super(key: key);

  @override
  _DriverListPageState createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  bool isLoading = true;
  late List<DriverModel> drivers;
  late List<DriverModel> filterDriver;

  String isAvailable = "All";

  getAllDriver() async {
    setState(() {
      isLoading = true;
      isFilter = false;
      isAvailable = "All";
    });
    drivers = [];
    await AppData().getDrivers().then((value) {
      drivers = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isFilter = false;
  String searchValue = "";

  filterResult({required String type}) {
    if (type == "Available") {
      setState(() {
        filterDriver = [];
        filterDriver =
            drivers.where((element) => element.available == 1).toList();

        isFilter = true;
      });
    } else if (type == "Not Available") {
      setState(() {
        filterDriver = [];
        filterDriver =
            drivers.where((element) => element.available == 0).toList();

        isFilter = true;
      });
    } else {
      setState(() {
        isFilter = false;
      });
    }
  }

  @override
  void initState() {
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
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.end,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 420,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "searchByPhone".tr(),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Ionicons.search)),
                        onChanged: (v) {
                          setState(() {
                            searchValue = v;
                          });
                        },
                      ),
                    ),
                    FilterChip(
                      label: Text("all".tr()),
                      onSelected: (bool value) {
                        setState(() {
                          isAvailable = "All";
                          filterResult(type: "All");
                        });
                      },
                      selected: isAvailable == "All",
                      backgroundColor: AppThemes.lightGreyColor,
                      selectedColor: AppThemes.primaryColor,
                      checkmarkColor: AppThemes.lightGreyColor,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: isAvailable == "All"
                                  ? AppThemes.lightGreyColor
                                  : AppThemes.darkColor),
                    ),
                    FilterChip(
                      label: Text("available".tr()),
                      onSelected: (bool value) {
                        setState(() {
                          isAvailable = "Available";
                          filterResult(type: "Available");
                        });
                      },
                      selected: isAvailable == "Available",
                      backgroundColor: AppThemes.lightGreyColor,
                      selectedColor: AppThemes.primaryColor,
                      checkmarkColor: AppThemes.lightGreyColor,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: isAvailable == "Available"
                                  ? AppThemes.lightGreyColor
                                  : AppThemes.darkColor),
                    ),
                    FilterChip(
                      label: Text("notAvailable".tr()),
                      onSelected: (bool value) {
                        setState(() {
                          isAvailable = "Not Available";
                          filterResult(type: "Not Available");
                        });
                      },
                      selected: isAvailable == "Not Available",
                      backgroundColor: AppThemes.lightGreyColor,
                      selectedColor: AppThemes.primaryColor,
                      checkmarkColor: AppThemes.lightGreyColor,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: isAvailable == "Not Available"
                                  ? AppThemes.lightGreyColor
                                  : AppThemes.darkColor),
                    ),
                  ],
                ),
                BsRow(
                    children: List.generate(
                        isFilter ? filterDriver.length : drivers.length,
                        (index) {
                  DriverModel driver =
                      isFilter ? filterDriver[index] : drivers[index];

                  bool isAvailable = driver.available == 1;
                  if (searchValue == "") {
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
                        title: Text(driver.name,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              driver.phone,
                            ),
                            isAvailable
                                ? Chip(
                                    backgroundColor: Colors.green,
                                    label: Text(
                                      "available".tr(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    avatar: const Icon(
                                      Ionicons.checkmark_circle,
                                      color: Colors.white,
                                    ),
                                  )
                                : Chip(
                                    backgroundColor: Colors.red,
                                    label: Text(
                                      "notAvailable".tr(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    avatar: const Icon(
                                      Ionicons.close_circle,
                                      color: Colors.white,
                                    ),
                                  )
                          ],
                        ),
                        minLeadingWidth: 0,
                        leading: const Icon(Ionicons.bicycle),
                        trailing: PopupMenuButton(
                            offset: const Offset(0, 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: EdgeRadius.all(10)),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem<int>(
                                  value: 0,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Ionicons.call,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(child: Text("callDriver".tr())),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Ionicons.copy,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                          child: Text("copyPhoneNumber".tr())),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Ionicons.notifications,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                          child: Text("sendNotification".tr())),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 3,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Ionicons.close_circle,
                                        color: context.color.error,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                          child: Text("deleteDriver".tr())),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            onSelected: (value) async {
                              switch (value) {
                                case 0:
                                  js.context.callMethod(
                                      'open', ['tel:${driver.phone}']);
                                  break;
                                case 1:
                                  Clipboard.setData(
                                          ClipboardData(text: driver.phone))
                                      .then((_) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      "phoneCopied".tr(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )));
                                  });
                                  break;
                                case 2:
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        String title = "";
                                        String description = "";
                                        return StatefulBuilder(
                                            builder: (context, ssNotify) {
                                          return AlertDialog(
                                            title:
                                                Text("sendNotification".tr()),
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    EdgeRadius.all(16)),
                                            content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                    hintText:
                                                        "description".tr(),
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
                                                            toUser:
                                                                "${driver.id}",
                                                            title: title,
                                                            body: description,
                                                          );
                                                        },
                                                        child:
                                                            Text("send".tr())),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child:
                                                          Text("cancel".tr()),
                                                      style: Get
                                                          .theme
                                                          .elevatedButtonTheme
                                                          .style!
                                                          .copyWith(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .red)),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                      });
                                  break;
                                case 3:
                                  AppWidgets().MyDialog(
                                    context: context,
                                    background: Colors.blue,
                                    title: "delete".tr(),
                                    subtitle: "deleteDriverDescription".tr(),
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
                                            asset:
                                                const CircularProgressIndicator(
                                                    color: Colors.white));
                                        await AppData()
                                            .deleteDriver(
                                                driverId: "${driver.id}")
                                            .then((value) async {
                                          Get.back();
                                          if (value['type'] == "success") {
                                            setState(() {
                                              getAllDriver();
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
                                      style: Get
                                          .theme.elevatedButtonTheme.style!
                                          .copyWith(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red)),
                                    ),
                                    cancel: ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text("no".tr()),
                                      style: Get
                                          .theme.elevatedButtonTheme.style!
                                          .copyWith(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.blueGrey)),
                                    ),
                                  );
                                  break;
                                default:
                                  break;
                              }
                            }),
                      ),
                    );
                  } else if (searchValue != "" &&
                      (driver.name
                              .toLowerCase()
                              .contains(searchValue.toLowerCase()) ||
                          driver.phone
                              .toLowerCase()
                              .contains(searchValue.toLowerCase()))) {
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
                        title: Text(driver.name,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              driver.phone,
                            ),
                            isAvailable
                                ? Chip(
                                    backgroundColor: Colors.green,
                                    label: Text(
                                      "available".tr(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    avatar: const Icon(
                                      Ionicons.checkmark_circle,
                                      color: Colors.white,
                                    ),
                                  )
                                : Chip(
                                    backgroundColor: Colors.red,
                                    label: Text(
                                      "notAvailable".tr(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    avatar: const Icon(
                                      Ionicons.close_circle,
                                      color: Colors.white,
                                    ),
                                  )
                          ],
                        ),
                        minLeadingWidth: 0,
                        leading: const Icon(Ionicons.bicycle),
                        trailing: PopupMenuButton(
                            offset: const Offset(0, 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: EdgeRadius.all(10)),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem<int>(
                                  value: 0,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Ionicons.call,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(child: Text("callDriver".tr())),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Ionicons.copy,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                          child: Text("copyPhoneNumber".tr())),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Ionicons.notifications,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                          child: Text("sendNotification".tr())),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 3,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Ionicons.close_circle,
                                        color: context.color.error,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                          child: Text("deleteDriver".tr())),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            onSelected: (value) async {
                              switch (value) {
                                case 0:
                                  break;
                                case 1:
                                  Clipboard.setData(
                                          ClipboardData(text: driver.phone))
                                      .then((_) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      "phoneCopied".tr(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )));
                                  });
                                  break;
                                case 2:
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        String title = "";
                                        String description = "";
                                        return StatefulBuilder(
                                            builder: (context, ssNotify) {
                                          return AlertDialog(
                                            title:
                                                Text("sendNotification".tr()),
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    EdgeRadius.all(16)),
                                            content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                    hintText:
                                                        "description".tr(),
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
                                                            toUser:
                                                                "${driver.id}",
                                                            title: title,
                                                            body: description,
                                                          );
                                                        },
                                                        child:
                                                            Text("send".tr())),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child:
                                                          Text("cancel".tr()),
                                                      style: Get
                                                          .theme
                                                          .elevatedButtonTheme
                                                          .style!
                                                          .copyWith(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .red)),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                      });
                                  break;
                                case 3:
                                  AppWidgets().MyDialog(
                                    context: context,
                                    background: Colors.blue,
                                    title: "delete".tr(),
                                    subtitle: "deleteDriverDescription".tr(),
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
                                            asset:
                                                const CircularProgressIndicator(
                                                    color: Colors.white));
                                        await AppData()
                                            .deleteDriver(
                                                driverId: "${driver.id}")
                                            .then((value) async {
                                          Get.back();
                                          if (value['type'] == "success") {
                                            setState(() {
                                              getAllDriver();
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
                                      style: Get
                                          .theme.elevatedButtonTheme.style!
                                          .copyWith(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red)),
                                    ),
                                    cancel: ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text("no".tr()),
                                      style: Get
                                          .theme.elevatedButtonTheme.style!
                                          .copyWith(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.blueGrey)),
                                    ),
                                  );
                                  break;
                                default:
                                  break;
                              }
                            }),
                      ),
                    );
                  } else {
                    return const BsCol(
                      sizes: ColScreen(
                        xs: Col.zero,
                        sm: Col.zero,
                        md: Col.zero,
                        lg: Col.zero,
                        xl: Col.zero,
                        xxl: Col.zero,
                      ),
                    );
                  }
                })),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var result = await Get.to(() => const AddDriverPage());
          if (result != null) {
            setState(() {
              getAllDriver();
            });
          }
        },
        label: Text("addDriver".tr()),
        icon: const Icon(Ionicons.add),
        backgroundColor: context.color.primary,
      ),
    );
  }
}
