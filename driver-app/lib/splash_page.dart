import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:store_driver/login/login_page.dart';
import 'package:store_driver/main.dart';
import 'package:store_driver/utils/app_themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  goToLogin() {
    if (auth.currentUser != null) {
      Future.delayed(Duration(seconds: 5), () => Get.offAll(() => MainPage()));
    } else {
      Future.delayed(Duration(seconds: 5), () => Get.offAll(() => LoginPage()));
    }
  }

  @override
  void initState() {
    goToLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppThemes.logoColor,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Headline3(
                "companyName".tr().replaceAll(" ", "\n"),
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
