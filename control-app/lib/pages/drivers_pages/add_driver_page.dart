import 'package:bs_flutter/bs_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:messini_store/models/driver_model.dart';
import 'package:messini_store/utils/app_helper.dart';
import 'package:messini_store/utils/app_themes.dart';
import 'package:messini_store/utils/app_widgets.dart';

class AddDriverPage extends StatefulWidget {
  const AddDriverPage({Key? key}) : super(key: key);

  @override
  _AddDriverPageState createState() => _AddDriverPageState();
}

class _AddDriverPageState extends State<AddDriverPage> {
  String driverNameValue = "";
  String driverPhoneValue = "";
  String driverPasswordValue = "";
  PhoneNumber number = PhoneNumber(isoCode: 'DZ');

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Headline6(
          "addDriver".tr(),
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
                      labelText: "driverName".tr(),
                      filled: true,
                    ),
                    onChanged: (v) {
                      setState(() {
                        driverNameValue = v;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      setState(() {
                        driverPhoneValue = "${number.phoneNumber}";
                      });
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG,
                      useEmoji: true,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    initialValue: number,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputDecoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "driverPhone".tr(),
                      filled: true,
                    ),
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
                          .addDriver(
                              driver: DriverModel(
                                  name: driverNameValue,
                                  phone: driverPhoneValue,
                                  available: 1))
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
                              title: "driverCreated".tr(),
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
                              title: "driverNotCreated".tr(),
                              confirm: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("back".tr())));
                        }
                      });
                    },
                    child: Text("addDriver".tr()),
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
