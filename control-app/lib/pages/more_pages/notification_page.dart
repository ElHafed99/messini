import 'dart:convert';

import 'package:bs_flutter/bs_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:messini_store/utils/app_helper.dart';
import 'package:messini_store/utils/app_themes.dart';
import 'package:messini_store/utils/app_widgets.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = true;
  late List<Map<String, dynamic>> notifications;

  getAllNotification() async {
    setState(() {
      isLoading = true;
    });
    notifications = [];
    await AppData().getNotifications().then((value) {
      notifications = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    getAllNotification();
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
                BsRow(
                  children: List.generate(notifications.length, (index) {
                    Map<String, dynamic> notification = notifications[index];
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
                        title: SelectableText(notification['title'],
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: SelectableText(
                          notification['description'],
                        ),
                        minLeadingWidth: 0,
                        leading: Card(
                            color: notification['toUser'] == "user"
                                ? Colors.blue
                                : notification['toUser'] == "driver"
                                    ? Colors.orange
                                    : context.color.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: EdgeRadius.all(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                notification['toUser'] == "user"
                                    ? Ionicons.people
                                    : notification['toUser'] == "driver"
                                        ? Ionicons.bicycle
                                        : Ionicons.notifications,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    );
                  }),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                String toUser = "all";
                String title = "";
                String description = "";
                return StatefulBuilder(builder: (context, ssNotify) {
                  return AlertDialog(
                    title: Text("sendNotification".tr()),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: EdgeRadius.all(16)),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("sendTo".tr()),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            FilterChip(
                              label: Text("all".tr()),
                              selected: toUser == "all",
                              backgroundColor: AppThemes.lightGreyColor,
                              selectedColor: AppThemes.primaryColor,
                              onSelected: (v) {
                                ssNotify(() {
                                  toUser = "all";
                                });
                              },
                              checkmarkColor: AppThemes.lightGreyColor,
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                      color: toUser == "all"
                                          ? AppThemes.lightGreyColor
                                          : AppThemes.darkColor),
                            ),
                            FilterChip(
                              label: Text("users".tr()),
                              selected: toUser == "user",
                              backgroundColor: AppThemes.lightGreyColor,
                              selectedColor: AppThemes.primaryColor,
                              onSelected: (v) {
                                ssNotify(() {
                                  toUser = "user";
                                });
                              },
                              checkmarkColor: AppThemes.lightGreyColor,
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                      color: toUser == "user"
                                          ? AppThemes.lightGreyColor
                                          : AppThemes.darkColor),
                            ),
                            FilterChip(
                              label: Text("drivers".tr()),
                              selected: toUser == "driver",
                              backgroundColor: AppThemes.lightGreyColor,
                              selectedColor: AppThemes.primaryColor,
                              onSelected: (v) {
                                ssNotify(() {
                                  toUser = "driver";
                                });
                              },
                              checkmarkColor: AppThemes.lightGreyColor,
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                      color: toUser == "driver"
                                          ? AppThemes.lightGreyColor
                                          : AppThemes.darkColor),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                                  AppWidgets().MyDialog(
                                      context: context,
                                      title: "loading".tr(),
                                      background: Colors.blue,
                                      asset: const CircularProgressIndicator(
                                          color: Colors.white));
                                  AppData()
                                      .sendNotification(
                                    toUser: toUser,
                                    title: title,
                                    body: description,
                                  )
                                      .then((value) {
                                    var data = jsonDecode(value.body);
                                    if (data['message_id'] != null &&
                                        data['message_id'] != '') {
                                      AppData()
                                          .addNotification(
                                        toUser: toUser,
                                        title: title,
                                        description: description,
                                      )
                                          .then((value) {
                                        getAllNotification();
                                      });
                                      Get.back();
                                    } else {
                                      Get.back();
                                      AppWidgets().MyDialog(
                                          context: context,
                                          asset: const Icon(
                                            Ionicons.close_circle,
                                            size: 80,
                                            color: Colors.white,
                                          ),
                                          background: const Color(0xffDF2E2E),
                                          title: "notificationNotSent".tr(),
                                          confirm: ElevatedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text("back".tr())));
                                    }
                                  });
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
                              style: Get.theme.elevatedButtonTheme.style!
                                  .copyWith(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                });
              });
        },
        label: Text("newNotification".tr()),
        icon: const Icon(Ionicons.add),
        backgroundColor: context.color.primary,
      ),
    );
  }
}
