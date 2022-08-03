import 'package:bs_flutter/bs_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:messini_store/models/category_model.dart';
import 'package:messini_store/utils/app_helper.dart';
import 'package:messini_store/utils/app_themes.dart';
import 'package:messini_store/utils/app_widgets.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  String categoryTitleValue = "";
  String categoryImageValue = "";
  bool showToUser = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Headline6(
          "addCategory".tr(),
          style: const TextStyle(
              color: AppThemes.lightGreyColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        controller: ScrollController(),
        padding: const Margin.all(16.0),
        shrinkWrap: true,
        children: [
          BsRow(alignment: Alignment.center, children: <BsCol>[
            BsCol(
              decoration: const BoxDecoration(),
              padding: const Margin.all(20.0),
              sizes: const ColScreen(
                xs: Col.col_12,
                sm: Col.col_6,
                md: Col.col_6,
                lg: Col.col_5,
                xl: Col.col_4,
                xxl: Col.col_3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Headline5(
                    "design".tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    width: 140,
                    decoration: BoxDecoration(
                        borderRadius: EdgeRadius.all(10), color: Colors.white),
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 2,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: EdgeRadius.all(10),
                                child: CachedNetworkImage(
                                  imageUrl: categoryImageValue,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3)),
                              ),
                              Center(
                                child: Headline6(
                                  categoryTitleValue,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BsCol(
              decoration: const BoxDecoration(),
              padding: const Margin.all(20.0),
              sizes: const ColScreen(
                xs: Col.col_12,
                sm: Col.col_6,
                md: Col.col_6,
                lg: Col.col_4,
                xl: Col.col_4,
                xxl: Col.col_3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Headline5(
                    "information".tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "categoryTitle".tr(),
                      filled: true,
                    ),
                    onChanged: (v) {
                      setState(() {
                        categoryTitleValue = v;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "categoryImage".tr(),
                      filled: true,
                    ),
                    onChanged: (v) {
                      setState(() {
                        categoryImageValue = v;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CheckboxListTile(
                    tileColor: const Color(0xffeaecf5),
                    title: Text("showToUsers".tr()),
                    value: showToUser,
                    onChanged: (bool? value) {
                      setState(() {
                        showToUser = !showToUser;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      AppWidgets().MyDialog(
                          context: context,
                          title: "loading".tr(),
                          background: Colors.blue,
                          asset: const CircularProgressIndicator(
                              color: Colors.white));
                      await AppData()
                          .addCategory(
                              category: CategoryModel(
                                  title: categoryTitleValue,
                                  image: categoryImageValue,
                                  showToUser: showToUser ? 1 : 0))
                          .then((value) {
                        Get.back();
                        if (value['type'] == "success") {
                          AppWidgets().MyDialog(
                              context: context,
                              asset: const Icon(
                                Ionicons.checkmark_circle,
                                size: 80,
                                color: Colors.white,
                              ),
                              background: context.color.primary,
                              title: "categoryCreated".tr(),
                              confirm: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    Get.back(result: true);
                                  },
                                  child: Text("back".tr())));
                        } else {
                          AppWidgets().MyDialog(
                              context: context,
                              asset: const Icon(
                                Ionicons.close_circle,
                                size: 80,
                                color: Colors.white,
                              ),
                              background: const Color(0xffDF2E2E),
                              title: "categoryNotCreated".tr(),
                              confirm: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("back".tr())));
                        }
                      });
                    },
                    child: Text("addCategory".tr()),
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
