import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';

class AppWidgets {
  MyDialog(
          {required BuildContext context,
          String? title,
          String? subtitle,
          Color? background,
          Widget? confirm,
          Widget? cancel,
          required Widget asset}) =>
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                contentPadding: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(16)),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: Margin.all(16),
                      color: background,
                      child: Center(child: asset),
                    ),
                    Container(
                      padding: Margin.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          title != null ? Headline6(title) : const SizedBox(),
                          subtitle != null
                              ? BodyText1(
                                  subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const Margin.horizontal(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          confirm ?? const SizedBox(),
                          SizedBox(
                            width: 10,
                          ),
                          cancel ?? const SizedBox(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });

  EmptyDataWidget({
    required String title,
    required IconData icon,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.grey,
            size: Get.size.width / 2,
          ),
          Headline5(
            title,
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
