import 'package:bs_flutter/bs_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:messini_store/models/product_model.dart';
import 'package:messini_store/pages/product_pages/add_product_page.dart';
import 'package:messini_store/pages/product_pages/edit_product_page.dart';
import 'package:messini_store/utils/app_const.dart';
import 'package:messini_store/utils/app_helper.dart';
import 'package:messini_store/utils/app_themes.dart';
import 'package:messini_store/utils/app_widgets.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  bool isLoading = true;
  late List<ProductModel> products;
  late List<ProductModel> filterProduct;
  getAllProduct() async {
    setState(() {
      isLoading = true;
      isFilter = false;
      showToUser = "All";
    });
    products = [];
    await AppData().getAllProducts().then((value) {
      products = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isFilter = false;
  String searchValue = "";

  filterResult({required String type}) {
    if (type == "Visible") {
      setState(() {
        filterProduct = [];
        filterProduct =
            products.where((element) => element.showToUser == 1).toList();

        isFilter = true;
      });
    } else if (type == "Invisible") {
      setState(() {
        filterProduct = [];
        filterProduct =
            products.where((element) => element.showToUser == 0).toList();

        isFilter = true;
      });
    } else {
      setState(() {
        isFilter = false;
      });
    }
  }

  String showToUser = "All";

  @override
  void initState() {
    getAllProduct();
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
                            labelText: "productSearch".tr(),
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
                          showToUser = "All";
                          filterResult(type: "All");
                        });
                      },
                      selected: showToUser == "All",
                      backgroundColor: AppThemes.lightGreyColor,
                      selectedColor: AppThemes.primaryColor,
                      checkmarkColor: AppThemes.lightGreyColor,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: showToUser == "All"
                                  ? AppThemes.lightGreyColor
                                  : AppThemes.darkColor),
                    ),
                    FilterChip(
                      label: Text("visible".tr()),
                      onSelected: (bool value) {
                        setState(() {
                          showToUser = "Visible";
                          filterResult(type: "Visible");
                        });
                      },
                      selected: showToUser == "Visible",
                      backgroundColor: AppThemes.lightGreyColor,
                      selectedColor: AppThemes.primaryColor,
                      checkmarkColor: AppThemes.lightGreyColor,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: showToUser == "Visible"
                                  ? AppThemes.lightGreyColor
                                  : AppThemes.darkColor),
                    ),
                    FilterChip(
                      label: Text("invisible".tr()),
                      onSelected: (bool value) {
                        setState(() {
                          showToUser = "Invisible";
                          filterResult(type: "Invisible");
                        });
                      },
                      selected: showToUser == "Invisible",
                      backgroundColor: AppThemes.lightGreyColor,
                      selectedColor: AppThemes.primaryColor,
                      checkmarkColor: AppThemes.lightGreyColor,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: showToUser == "Invisible"
                                  ? AppThemes.lightGreyColor
                                  : AppThemes.darkColor),
                    ),
                  ],
                ),
                BsRow(
                    //alignment: Alignment.center,
                    children: List.generate(
                        isFilter ? filterProduct.length : products.length,
                        (index) {
                  ProductModel product =
                      isFilter ? filterProduct[index] : products[index];
                  if (searchValue == "") {
                    return BsCol(
                      padding: const Margin.all(5.0),
                      sizes: const ColScreen(
                        xs: Col.col_6,
                        sm: Col.col_3,
                        md: Col.col_3,
                        lg: Col.col_3,
                        xl: Col.col_3,
                        xxl: Col.col_2,
                      ),
                      //color: context.color.primary.withOpacity(0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: EdgeRadius.all(10),
                              color: product.showToUser == 1
                                  ? Colors.white
                                  : Colors.red.shade50,
                            ),
                            clipBehavior: Clip.antiAlias,
                            padding: const Margin.all(10),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: EdgeRadius.all(10),
                                  child: CachedNetworkImage(
                                    imageUrl: product.image,
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 85,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                BodyText1(
                                  product.title,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                BodyText2(
                                  "${product.price} ${AppConst.appCurrency}",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: context.color.primary,
                                      fontWeight: FontWeight.bold),
                                ),
                                BodyText2(
                                  "${product.unitSize} ${product.unit}",
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Divider(),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    ActionChip(
                                      onPressed: () async {
                                        var result = await Get.to(() =>
                                            EditProductPage(product: product));
                                        if (result != null) {
                                          setState(() {
                                            getAllProduct();
                                          });
                                        }
                                      },
                                      label: Text(
                                        "edit".tr(),
                                        style: TextStyle(
                                            color: context.color.primary),
                                      ),
                                      avatar: Icon(Ionicons.create_outline,
                                          color: context.color.primary),
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                    ActionChip(
                                      onPressed: () {
                                        AppWidgets().MyDialog(
                                          context: context,
                                          background: Colors.blue,
                                          title: "delete".tr(),
                                          subtitle: "deleteProduct".tr(),
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
                                                  .deleteProduct(
                                                      productId:
                                                          "${product.id}")
                                                  .then((value) async {
                                                Get.back();
                                                if (value['type'] ==
                                                    "success") {
                                                  setState(() {
                                                    getAllProduct();
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
                                                          child:
                                                              Text("ok".tr())));
                                                }
                                              });
                                            },
                                            child: Text("yes".tr()),
                                            style: Get.theme.elevatedButtonTheme
                                                .style!
                                                .copyWith(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red)),
                                          ),
                                          cancel: ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text("no".tr()),
                                            style: Get.theme.elevatedButtonTheme
                                                .style!
                                                .copyWith(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .blueGrey)),
                                          ),
                                        );
                                      },
                                      label: Text(
                                        "delete".tr(),
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                      avatar: const Icon(
                                        Ionicons.close_circle,
                                        color: Colors.red,
                                      ),
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (searchValue != "" &&
                      (product.title
                              .toLowerCase()
                              .contains(searchValue.toLowerCase()) ||
                          product.price
                              .toString()
                              .toLowerCase()
                              .contains(searchValue.toLowerCase()) ||
                          product.unit
                              .toLowerCase()
                              .contains(searchValue.toLowerCase()) ||
                          product.unitSize
                              .toString()
                              .toLowerCase()
                              .contains(searchValue.toLowerCase()))) {
                    return BsCol(
                      padding: const Margin.all(5.0),
                      sizes: const ColScreen(
                        xs: Col.col_6,
                        sm: Col.col_3,
                        md: Col.col_3,
                        lg: Col.col_3,
                        xl: Col.col_3,
                        xxl: Col.col_2,
                      ),
                      //color: context.color.primary.withOpacity(0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: EdgeRadius.all(10),
                              color: product.showToUser == 1
                                  ? Colors.white
                                  : Colors.red.shade50,
                            ),
                            clipBehavior: Clip.antiAlias,
                            padding: const Margin.all(10),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: EdgeRadius.all(10),
                                  child: CachedNetworkImage(
                                    imageUrl: product.image,
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 85,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                BodyText1(
                                  product.title,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                BodyText2(
                                  "${product.price} ${AppConst.appCurrency}",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: context.color.primary,
                                      fontWeight: FontWeight.bold),
                                ),
                                BodyText2(
                                  "${product.unitSize} ${product.unit}",
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Divider(),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    ActionChip(
                                      onPressed: () async {
                                        var result = await Get.to(() =>
                                            EditProductPage(product: product));
                                        if (result != null) {
                                          setState(() {
                                            getAllProduct();
                                          });
                                        }
                                      },
                                      label: Text(
                                        "edit".tr(),
                                        style: TextStyle(
                                            color: context.color.primary),
                                      ),
                                      avatar: Icon(Ionicons.create_outline,
                                          color: context.color.primary),
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                    ActionChip(
                                      onPressed: () {
                                        AppWidgets().MyDialog(
                                          context: context,
                                          background: Colors.blue,
                                          title: "delete".tr(),
                                          subtitle: "deleteProduct".tr(),
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
                                                  .deleteProduct(
                                                      productId:
                                                          "${product.id}")
                                                  .then((value) async {
                                                Get.back();
                                                if (value['type'] ==
                                                    "success") {
                                                  setState(() {
                                                    getAllProduct();
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
                                                          child:
                                                              Text("ok".tr())));
                                                }
                                              });
                                            },
                                            child: Text("yes".tr()),
                                            style: Get.theme.elevatedButtonTheme
                                                .style!
                                                .copyWith(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red)),
                                          ),
                                          cancel: ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text("no".tr()),
                                            style: Get.theme.elevatedButtonTheme
                                                .style!
                                                .copyWith(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .blueGrey)),
                                          ),
                                        );
                                      },
                                      label: Text(
                                        "delete".tr(),
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                      avatar: const Icon(
                                        Ionicons.close_circle,
                                        color: Colors.red,
                                      ),
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
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
          var result = await Get.to(() => const AddProductPage());
          if (result != null) {
            setState(() {
              getAllProduct();
            });
          }
        },
        label: Text("addProduct".tr()),
        icon: const Icon(Ionicons.add),
        backgroundColor: context.color.primary,
      ),
    );
  }
}
