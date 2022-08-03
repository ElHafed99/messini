import 'package:aftersad_store/main.dart';
import 'package:aftersad_store/utils/app_helper.dart';
import 'package:aftersad_store/utils/app_themes.dart';
import 'package:aftersad_store/utils/app_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pinput/pinput.dart';

class PincodePage extends StatefulWidget {
  final String phoneNumber;

  const PincodePage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _PincodePageState createState() => _PincodePageState();
}

class _PincodePageState extends State<PincodePage> {
  String? _verificationCode;
  String verificationID = "";

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  bool isSendLoading = true;
  bool checkPinLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  _verifyPhone() async {
    await auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          //await auth.signInWithCredential(credential);
          /* .then((value) async {
            if (value.user != null) {
              print(value.user!.phoneNumber);
            }
          });*/
        },
        verificationFailed: (FirebaseAuthException e) {
          print("-" * 50);
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          print("code sent");
          setState(() {
            _verificationCode = verificationId;
            verificationID = verificationId;
            isSendLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          /* setState(() {
            //_verificationCode = verificationID;
          });*/
        },
        timeout: const Duration(minutes: 2));
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
                      // PhoneAuthCredential credential =
                      //     PhoneAuthProvider.credential(
                      //         verificationId: verificationID, smsCode: pin);
                      //
                      // await auth.signInWithCredential(credential);

                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationID, smsCode: pin);
                        await auth
                            .signInWithCredential(credential)
                            .then((value) async {
                          print(value.user.toString());
                          if (value.user != null) {
                            await FirebaseMessaging.instance
                                .subscribeToTopic("user");
                            await FirebaseMessaging.instance
                                .subscribeToTopic(auth.currentUser!.uid);

                            await AppData().checkUserExist(
                                userUid: value.user!.uid,
                                userPhone: "${value.user!.phoneNumber}");

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
                        print("-" * 50);
                        print("$e");
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
