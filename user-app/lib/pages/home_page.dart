import 'package:aftersad_store/main.dart';
import 'package:aftersad_store/utils/app_themes.dart';
import 'package:aftersad_store/widgets/category_widget.dart';
import 'package:aftersad_store/widgets/latest_product_widget.dart';
import 'package:aftersad_store/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool productViewGrid = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Headline6(
            "home".tr(),
            style: TextStyle(
                color: AppThemes.lightGreyColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: () {
            Get.offAll(() => MainPage());
            _refreshController.refreshCompleted();
          },
          child: ListView(
            padding: const Margin.all(8.0),
            children: [
              const SliderWidget(),
              ListTile(
                title: Headline6(
                  "categories".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: ElevatedButton(
                    onPressed: () => Get.offAll(() => const MainPage(
                          selectedIndex: 1,
                        )),
                    child: Text("viewAll".tr())),
              ),
              const CategoryWidget(
                maxCategory: 4,
                childPerLine: 2,
              ),
              ListTile(
                title: Headline6(
                  "latestProduct".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        productViewGrid = !productViewGrid;
                      });
                    },
                    icon:
                        Icon(!productViewGrid ? Ionicons.grid : Ionicons.list)),
              ),
              LatestProductWidget(productViewGrid: productViewGrid)
            ],
          ),
        ),
      ),
    );
  }
}
