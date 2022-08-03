import 'package:aftersad_store/main.dart';
import 'package:aftersad_store/utils/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets/category_widget.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.white,
        title: Headline6("categories".tr(),
            style: TextStyle(
                color: AppThemes.lightGreyColor, fontWeight: FontWeight.bold)),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () {
          Get.offAll(() => MainPage(
                selectedIndex: 1,
              ));
          _refreshController.refreshCompleted();
        },
        child: CategoryWidget(
          childPerLine: 2,
        ),
      ),
    );
  }
}
