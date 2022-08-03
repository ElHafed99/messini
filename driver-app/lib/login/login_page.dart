import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:store_driver/login/pincode_page.dart';
import 'package:store_driver/utils/app_helper.dart';
import 'package:store_driver/utils/app_themes.dart';
import 'package:store_driver/utils/app_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controller = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'DZ');
  String? phoneNumber;

  checkDriverNumber() async {
    AppWidgets().MyDialog(
        context: context,
        title: "loading".tr(),
        background: Colors.blue,
        asset: const CircularProgressIndicator(color: Colors.white));
    await AppData()
        .getDriverByPhone(driverPhone: "$phoneNumber")
        .then((result) {
      if (result['type'] == "success") {
        Get.back();
        Get.to(() => PincodePage(
              phoneNumber: phoneNumber!,
              driverData: result['data'],
            ));
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
            title: "phoneNotFound".tr(),
            confirm: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("back".tr())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Headline6(
            "signup".tr(),
            style: TextStyle(
                color: AppThemes.lightGreyColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.all(32.0),
            children: [
              Headline5(
                "phoneNumber".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Headline6(
                "phoneNumberDescription".tr(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              Card(
                elevation: 0.0,
                shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      setState(() {
                        phoneNumber = number.phoneNumber;
                      });
                    },
                    onInputValidated: (bool value) {},
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG,
                      useEmoji: true,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    initialValue: number,
                    textFieldController: controller,
                    formatInput: false,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: InputBorder.none,
                    onSaved: (PhoneNumber number) {},
                  ),
                ),
              ),
              const SizedBox(
                height: 64,
              ),
              ListTile(
                onTap: controller.text.isNotEmpty
                    ? () {
                        checkDriverNumber();
                      }
                    : null,
                tileColor: controller.text.isNotEmpty
                    ? context.color.primary
                    : Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
                title: Center(
                  child: Headline6(
                    "sendCode".tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
