import 'dart:js' as js;

import 'package:bs_flutter/bs_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:messini_store/models/user_model.dart';
import 'package:messini_store/pages/users_pages/user_order_list.dart';
import 'package:messini_store/utils/app_helper.dart';
import 'package:messini_store/utils/app_widgets.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  bool isLoading = true;
  late List<UserModel> users;

  getAllUser() async {
    setState(() {
      isLoading = true;
    });
    users = [];
    await AppData().getUsers().then((value) {
      users = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  String searchValue = "";

  @override
  void initState() {
    getAllUser();
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
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 420,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "userSearch".tr(),
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
                ),
                BsRow(
                    children: List.generate(users.length, (index) {
                  UserModel user = users[index];
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
                        title: SelectableText(user.phone,
                            textAlign: TextAlign.start,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          user.uid,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        minLeadingWidth: 0,
                        leading: const Icon(Ionicons.person),
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
                                        Ionicons.bag_handle,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(child: Text("userOrders".tr())),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Ionicons.call,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(child: Text("callUser".tr())),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 2,
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
                                  value: 3,
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
                                  value: 4,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Ionicons.close_circle,
                                        color: context.color.error,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(child: Text("deleteUser".tr())),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            onSelected: (value) async {
                              switch (value) {
                                case 0:
                                  var result = await Get.to(() => UserOrderList(
                                        userUid: user.uid,
                                      ));
                                  if (result != null) {
                                    setState(() {
                                      getAllUser();
                                    });
                                  }
                                  break;
                                case 1:
                                  js.context.callMethod(
                                      'open', ['tel:${user.phone}']);
                                  break;
                                case 2:
                                  Clipboard.setData(
                                          ClipboardData(text: user.phone))
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
                                case 3:
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
                                                            toUser: user.uid,
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
                                case 4:
                                  AppWidgets().MyDialog(
                                    context: context,
                                    background: Colors.blue,
                                    title: "delete".tr(),
                                    subtitle: "deleteUserConfirmation".tr(),
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
                                            .deleteUser(userUid: user.uid)
                                            .then((value) async {
                                          Get.back();
                                          if (value['type'] == "success") {
                                            Get.back();
                                            setState(() {
                                              users.removeWhere((element) =>
                                                  element.uid == user.uid);
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
                  } else if ((searchValue != "" &&
                      (user.phone
                          .toLowerCase()
                          .contains(searchValue.toLowerCase())))) {
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
                        title: SelectableText(user.phone,
                            textAlign: TextAlign.start,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          user.uid,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        minLeadingWidth: 0,
                        leading: const Icon(Ionicons.person),
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
                                        Ionicons.bag_handle,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(child: Text("userOrders".tr())),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Ionicons.call,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(child: Text("callUser".tr())),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 2,
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
                                  value: 3,
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
                                  value: 4,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Ionicons.close_circle,
                                        color: context.color.error,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(child: Text("deleteUser".tr())),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            onSelected: (value) async {
                              switch (value) {
                                case 0:
                                  var result = await Get.to(() => UserOrderList(
                                        userUid: user.uid,
                                      ));
                                  if (result != null) {
                                    setState(() {
                                      getAllUser();
                                    });
                                  }
                                  break;
                                case 1:
                                  break;
                                case 2:
                                  Clipboard.setData(
                                          ClipboardData(text: user.phone))
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
                                case 3:
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
                                                            toUser: user.uid,
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
                                case 4:
                                  AppWidgets().MyDialog(
                                    context: context,
                                    background: Colors.blue,
                                    title: "delete".tr(),
                                    subtitle: "deleteUserConfirmation".tr(),
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
                                            .deleteUser(userUid: user.uid)
                                            .then((value) async {
                                          Get.back();
                                          if (value['type'] == "success") {
                                            Get.back();
                                            setState(() {
                                              users.removeWhere((element) =>
                                                  element.uid == user.uid);
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
    );
  }
}
