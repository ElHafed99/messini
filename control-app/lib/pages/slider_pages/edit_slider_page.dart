import 'package:bs_flutter/bs_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_color_picker/easy_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:messini_store/models/slider_model.dart';
import 'package:messini_store/utils/app_helper.dart';
import 'package:messini_store/utils/app_themes.dart';
import 'package:messini_store/utils/app_widgets.dart';
import 'package:validators/validators.dart';

class EditSliderPage extends StatefulWidget {
  final SliderModel slider;
  const EditSliderPage({Key? key, required this.slider}) : super(key: key);

  @override
  _EditSliderPageState createState() => _EditSliderPageState();
}

class _EditSliderPageState extends State<EditSliderPage> {
  TextEditingController sliderTitleCont = TextEditingController();
  TextEditingController sliderSubtitleCont = TextEditingController();
  TextEditingController sliderImageCont = TextEditingController();
  TextEditingController sliderColorCont = TextEditingController();

  bool isLoading = true;
  late String sliderTitleValue = widget.slider.title;
  late String sliderSubtitleValue = widget.slider.subtitle;
  late String sliderImageValue = "${widget.slider.image}";
  late String sliderColorValue = "${widget.slider.color}";
  late bool showToUser = widget.slider.showToUser == 1;

  @override
  void initState() {
    sliderTitleCont.text = widget.slider.title;
    sliderSubtitleCont.text = widget.slider.subtitle;
    sliderImageCont.text = "${widget.slider.image}";
    sliderColorCont.text = "${widget.slider.color}";

    isLoading = false;
    super.initState();
  }

  final List<Color> _colors = [
    Colors.white,
    ...Colors.primaries,
    ...Colors.accents
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Headline6(
          "editSlider".tr(),
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
                    decoration: BoxDecoration(
                        borderRadius: EdgeRadius.all(10), color: Colors.white),
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 2,
                          child: Container(
                              width: context.media.width,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: !isHexColor(sliderColorValue)
                                    ? const Color(0xffffffff)
                                    : Color(int.parse("0xff$sliderColorValue")),
                                borderRadius: EdgeRadius.all(10),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: sliderImageValue,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.transparent,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3)),
                                  ),
                                  Center(
                                    child: ListTile(
                                      title: Headline6(
                                        sliderTitleValue,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Subtitle1(
                                        sliderSubtitleValue,
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
                    controller: sliderTitleCont,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "sliderTitle".tr(),
                      filled: true,
                    ),
                    onChanged: (v) {
                      setState(() {
                        sliderTitleValue = v;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: sliderSubtitleCont,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "sliderSubtitle".tr(),
                      filled: true,
                    ),
                    onChanged: (v) {
                      setState(() {
                        sliderSubtitleValue = v;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: sliderImageCont,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "sliderImage".tr(),
                      filled: true,
                    ),
                    onChanged: (v) {
                      setState(() {
                        sliderImageValue = v;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-fA-F0-9]+$')),
                    ],
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "sliderColor".tr(),
                        filled: true,
                        counterText: ''),
                    maxLength: 6,
                    controller: sliderColorCont,
                    onChanged: (v) {
                      setState(() {
                        sliderColorValue = v;
                        if (isHexColor(v) && v.length > 3) {
                          _colors.add(Color(int.parse("0xff" + v)));
                        }
                      });
                    },
                  ),
                  EasyColorPicker(
                      selected: !isHexColor(sliderColorValue)
                          ? const Color(0xffffffff)
                          : Color(int.parse("0xff" + sliderColorValue)),
                      colors: _colors.toSet().toList(),
                      onChanged: (color) => setState(() {
                            sliderColorValue =
                                color.value.toRadixString(16).substring(2, 8);
                            sliderColorCont.text = sliderColorValue;
                          })),
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
                          .editSlider(
                              slider: SliderModel(
                        id: widget.slider.id,
                        title: sliderTitleValue,
                        subtitle: sliderSubtitleValue,
                        color: sliderColorValue,
                        image: sliderImageValue,
                        showToUser: showToUser ? 1 : 0,
                      ))
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
                              title: "sliderUpdated".tr(),
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
                              title: "sliderNotUpdated".tr(),
                              confirm: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("back".tr())));
                        }
                      });
                    },
                    child: Text("editSlider".tr()),
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
