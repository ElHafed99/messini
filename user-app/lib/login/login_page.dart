import 'package:aftersad_store/login/pincode_page.dart';
import 'package:aftersad_store/utils/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controller = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'DZ');
  String? phoneNumber;

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
            /*mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,*/
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
                "signupDescription".tr(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              Card(
                elevation: 0.0,
                //color: Colors.grey.shade200,
                shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
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
                        Get.to(() => PincodePage(phoneNumber: phoneNumber!));
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
