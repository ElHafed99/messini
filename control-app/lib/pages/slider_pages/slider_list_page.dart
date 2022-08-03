import 'package:bs_flutter/bs_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:messini_store/models/slider_model.dart';
import 'package:messini_store/pages/slider_pages/add_slider_page.dart';
import 'package:messini_store/pages/slider_pages/edit_slider_page.dart';
import 'package:messini_store/utils/app_helper.dart';
import 'package:messini_store/utils/app_themes.dart';
import 'package:messini_store/utils/app_widgets.dart';
import 'package:validators/validators.dart';

class SliderListPage extends StatefulWidget {
  const SliderListPage({Key? key}) : super(key: key);

  @override
  _SliderListPageState createState() => _SliderListPageState();
}

class _SliderListPageState extends State<SliderListPage> {
  bool isLoading = true;
  late List<SliderModel> sliders;
  late List<SliderModel> filterSlider;

  getAllSlider() async {
    setState(() {
      isLoading = true;
      isFilter = false;
      showToUser = "All";
    });
    sliders = [];
    await AppData().getAllSliders().then((value) {
      sliders = value;
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
        filterSlider = [];
        filterSlider =
            sliders.where((element) => element.showToUser == 1).toList();

        isFilter = true;
      });
    } else if (type == "Invisible") {
      setState(() {
        filterSlider = [];
        filterSlider =
            sliders.where((element) => element.showToUser == 0).toList();

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
    getAllSlider();
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
                            labelText: "sliderSearch".tr(),
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
                    children: List.generate(
                        isFilter ? filterSlider.length : sliders.length,
                        (index) {
                  SliderModel slider =
                      isFilter ? filterSlider[index] : sliders[index];
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
                              color: slider.showToUser == 1
                                  ? Colors.white
                                  : Colors.red.shade50,
                            ),
                            padding: const Margin.all(10),
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 2,
                                  child: Container(
                                      width: context.media.width,
                                      margin: const Margin.horizontal(5),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: !isHexColor(slider.color!)
                                            ? const Color(0xffffffff)
                                            : Color(int.parse(
                                                "0xff" + slider.color!)),
                                        borderRadius: EdgeRadius.all(10),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: slider.image!,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: Colors.transparent,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.3)),
                                          ),
                                          Center(
                                            child: ListTile(
                                              title: Headline6(
                                                slider.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Subtitle1(
                                                slider.subtitle,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                                const Divider(),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    ActionChip(
                                      onPressed: () async {
                                        var result = await Get.to(() =>
                                            EditSliderPage(slider: slider));
                                        if (result != null) {
                                          setState(() {
                                            getAllSlider();
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
                                          subtitle: "deleteSlider".tr(),
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
                                                  .deleteSlider(
                                                      sliderId: "${slider.id}")
                                                  .then((value) async {
                                                Get.back();
                                                if (value['type'] ==
                                                    "success") {
                                                  setState(() {
                                                    getAllSlider();
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
                      (slider.title
                              .toLowerCase()
                              .contains(searchValue.toLowerCase()) ||
                          slider.subtitle
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
                              color: slider.showToUser == 1
                                  ? Colors.white
                                  : Colors.red.shade50,
                            ),
                            padding: const Margin.all(10),
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 2,
                                  child: Container(
                                      width: context.media.width,
                                      margin: const Margin.horizontal(5),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: !isHexColor(slider.color!)
                                            ? const Color(0xffffffff)
                                            : Color(int.parse(
                                                "0xff" + slider.color!)),
                                        borderRadius: EdgeRadius.all(10),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: slider.image!,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: Colors.transparent,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.3)),
                                          ),
                                          Center(
                                            child: ListTile(
                                              title: Headline6(
                                                slider.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Subtitle1(
                                                slider.subtitle,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                                const Divider(),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    ActionChip(
                                      onPressed: () async {
                                        var result = await Get.to(() =>
                                            EditSliderPage(slider: slider));
                                        if (result != null) {
                                          setState(() {
                                            getAllSlider();
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
                                          subtitle: "deleteSlider".tr(),
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
                                                  .deleteSlider(
                                                      sliderId: "${slider.id}")
                                                  .then((value) async {
                                                Get.back();
                                                if (value['type'] ==
                                                    "success") {
                                                  setState(() {
                                                    getAllSlider();
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
          var result = await Get.to(() => const AddSliderPage());
          if (result != null) {
            setState(() {
              getAllSlider();
            });
          }
        },
        label: Text("addSlider".tr()),
        icon: const Icon(Ionicons.add),
        backgroundColor: context.color.primary,
      ),
    );
  }
}
