import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pinput/pinput.dart';
import 'package:store_driver/main.dart';
import 'package:store_driver/utils/app_themes.dart';
import 'package:store_driver/utils/app_widgets.dart';

class PincodePage extends StatefulWidget {
  final String phoneNumber;
  final Map<String, dynamic> driverData;

  const PincodePage(
      {Key? key, required this.phoneNumber, required this.driverData})
      : super(key: key);

  @override
  _PincodePageState createState() => _PincodePageState();
}

class _PincodePageState extends State<PincodePage> {
  String? _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  bool isSendLoading = true;
  bool checkPinLoading = false;

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {}
          });
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
            isSendLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: const Duration(seconds: 120));
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Headline6("verification".tr(),
            style: TextStyle(
                color: AppThemes.lightGreyColor, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: isSendLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Headline5(
                    "pleasWait".tr(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Headline6(
                    "pleasWaitDescription".tr(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: const LinearProgressIndicator(
                      minHeight: 10,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Headline5(
                    "pinCode".tr(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Headline6(
                    "${'enter6Digit'.tr()} ${widget.phoneNumber}",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Pinput(
                    length: 6,
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    pinAnimationType: PinAnimationType.fade,
                    onCompleted: (pin) async {
                      setState(() {
                        checkPinLoading = true;
                      });
                      try {
                        await FirebaseAuth.instance
                            .signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: _verificationCode!,
                                smsCode: pin))
                            .then((value) async {
                          if (value.user != null) {
                            await FirebaseMessaging.instance
                                .subscribeToTopic("driver");
                            await FirebaseMessaging.instance
                                .subscribeToTopic("${widget.driverData['id']}");

                            GetStorage().write("driverData", widget.driverData);
                            setState(() {
                              checkPinLoading = false;
                            });
                            AppWidgets().MyDialog(
                                context: context,
                                asset: const Icon(
                                  Ionicons.checkmark_circle,
                                  size: 80,
                                  color: Colors.white,
                                ),
                                background: context.color.primary,
                                title: "loginSuccess".tr(),
                                confirm: ElevatedButton(
                                    onPressed: () {
                                      Get.offAll(() => const MainPage());
                                    },
                                    child: Text("ok".tr())));
                          }
                        });
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          checkPinLoading = false;
                        });
                        AppWidgets().MyDialog(
                            context: context,
                            asset: const Icon(
                              Ionicons.close_circle,
                              size: 80,
                              color: Colors.white,
                            ),
                            background: const Color(0xffDF2E2E),
                            title: "invalidOtp".tr(),
                            confirm: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("back".tr())));
                      }
                    },
                  ),
                  checkPinLoading
                      ? const SizedBox(
                          height: 32,
                        )
                      : const SizedBox(),
                  checkPinLoading
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: const LinearProgressIndicator(
                            minHeight: 10,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
      ),
    );
  }
}
